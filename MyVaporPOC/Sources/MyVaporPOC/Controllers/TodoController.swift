/// # TodoController
/// Handles routes for managing Todo items. Supports listing all todos, creating new todos, and deleting by ID.

import Fluent
import Vapor

struct TodoController: RouteCollection {
    /// Registers the controller's endpoints with the routing system.
    func boot(routes: any RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: self.index)
        todos.post(use: self.create)
        todos.group(":todoID") { todo in
            todo.delete(use: self.delete)
        }
    }

    /// GET /todos - Retrieves all todos in the database.
    @Sendable
    func index(req: Request) async throws -> [TodoDTO] {
        // Return an empty list if no rows; always 200 OK
        let todos = try await Todo.query(on: req.db).all()
        return todos.map { $0.toDTO() }
    }

    /// POST /todos - Creates a new todo. The title field must be set and not empty.
    @Sendable
    func create(req: Request) async throws -> TodoDTO {
        let dto: TodoDTO
        do {
            dto = try req.content.decode(TodoDTO.self)
        } catch {
            // Invalid or missing body, return a 400 response
            throw Abort(.badRequest, reason: "Invalid request body")
        }

        guard let title = dto.title, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            throw Abort(.badRequest, reason: "The title field is required and cannot be empty.")
        }

        let todo = dto.toModel()
        try await todo.save(on: req.db)
        return todo.toDTO()
    }

    /// DELETE /todos/:todoID - Deletes a specific todo by its ID
    /// (delete and respond with .noContent if found, else 404).
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound, reason: "Todo item not found")
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
}
