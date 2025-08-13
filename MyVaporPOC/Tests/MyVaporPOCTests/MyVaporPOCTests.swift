/// # MyVaporPOCTests
///
/// Integration/API test suite for MyVaporPOC backend.
/// Uses VaporTesting for async, in-memory HTTP/DB tests.
/// Thoroughly covers: REST endpoints, CRUD, error handling, and edge cases.
///
import Fluent
import Testing
import VaporTesting

@testable import MyVaporPOC

@Suite("App Tests with DB", .serialized)
struct MyVaporPOCTests {

    /// Helper for isolated per-test app setup/teardown with in-memory DB for full test safety.
    private func withApp(_ test: (Application) async throws -> Void) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)  // App config & DB setup.
            try await app.autoMigrate()  // Run DB schema migrations.
            try await test(app)  // Run the test.
            try await app.autoRevert()  // Reset DB.
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    // MARK: - Happy Path Tests

    /// ✅ Happy Path: GET `/hello` endpoint returns correct greeting.
    @Test("GET /hello returns greeting")
    func helloWorld() async throws {
        try await withApp { app in
            try await app.testing().test(
                .GET, "hello",
                afterResponse: { res async in
                    #expect(res.status == .ok)
                    #expect(res.body.string == "Hello, world!")
                })
        }
    }

    /// ✅ Happy Path: GET `/todos` returns empty list when DB is empty.
    @Test("GET /todos returns empty list")
    func getTodosEmpty() async throws {
        try await withApp { app in
            try await app.testing().test(
                .GET, "todos",
                afterResponse: { res async throws in
                    #expect(res.status == .ok)
                    let todos = try res.content.decode([TodoDTO].self)
                    #expect(todos.isEmpty)
                })
        }
    }

    /// ✅ Happy Path: POST `/todos` creates new todo.
    @Test("POST /todos creates a todo")
    func createTodo() async throws {
        let dto = TodoDTO(id: nil, title: "integration test todo")
        try await withApp { app in
            try await app.testing().test(
                .POST, "todos",
                beforeRequest: { req in
                    try req.content.encode(dto)
                },
                afterResponse: { res async throws in
                    #expect(res.status == .ok)
                    let returned = try res.content.decode(TodoDTO.self)
                    #expect(returned.title == dto.title)
                    #expect(returned.id != nil)
                })
        }
    }

    /// ✅ Happy Path: GET `/todos` returns all todos.
    @Test("GET /todos returns all todos")
    func getAllTodos() async throws {
        try await withApp { app in
            let seeded = [Todo(title: "sample1"), Todo(title: "sample2")]
            try await seeded.create(on: app.db)
            try await app.testing().test(
                .GET, "todos",
                afterResponse: { res async throws in
                    #expect(res.status == .ok)
                    let dtos = try res.content.decode([TodoDTO].self)
                    let seededTitles = seeded.map(\.title)
                    #expect(Set(dtos.compactMap(\.title)) == Set(seededTitles))
                })
        }
    }

    /// ✅ Happy Path: DELETE `/todos/:id` deletes correct todo.
    @Test("DELETE /todos/:id deletes a todo")
    func deleteTodo() async throws {
        let t1 = Todo(title: "to-delete")
        let t2 = Todo(title: "to-keep")
        try await withApp { app in
            try await [t1, t2].create(on: app.db)
            guard let deleteId = t1.id else { throw Abort(.internalServerError) }
            try await app.testing().test(
                .DELETE, "todos/\(deleteId)",
                afterResponse: { res async throws in
                    #expect(res.status == .noContent)
                    let todos = try await Todo.query(on: app.db).all()
                    let titles = todos.map(\.title)
                    #expect(titles == ["to-keep"])
                })
        }
    }

    // MARK: - Edge/Negative Case Tests

    /// ❎ Negative: DELETE `/todos/:id` with nonexistent ID returns 404.
    @Test("DELETE /todos/:nonexistent returns 404")
    func deleteNonexistentTodo() async throws {
        try await withApp { app in
            let fakeId = UUID()
            try await app.testing().test(
                .DELETE, "todos/\(fakeId)",
                afterResponse: { res async throws in
                    #expect(res.status == .notFound)
                })
        }
    }

    /// ❎ Negative: POST `/todos` with missing title returns 400.
    @Test("POST /todos missing title returns error")
    func createTodoMissingTitle() async throws {
        try await withApp { app in
            try await app.testing().test(
                .POST, "todos",
                beforeRequest: { req in
                    try req.content.encode([String: String]())  // missing title
                },
                afterResponse: { res async throws in
                    #expect(res.status == .badRequest)
                })
        }
    }

    /// ❎ Negative: POST `/todos` with completely empty body returns 400.
    @Test("POST /todos with empty body returns error")
    func createTodoEmptyBody() async throws {
        try await withApp { app in
            try await app.testing().test(
                .POST, "todos",
                afterResponse: { res async throws in
                    #expect(res.status == .badRequest)
                })
        }
    }

    /// ❎ Negative: GET `/todos` is empty after deleting all items.
    @Test("GET /todos returns empty after deleting all")
    func deleteAllTodosCheckEmpty() async throws {
        try await withApp { app in
            let todo = Todo(title: "delete-me")
            try await todo.save(on: app.db)
            guard let id = todo.id else { throw Abort(.internalServerError) }
            try await app.testing().test(
                .DELETE, "todos/\(id)",
                afterResponse: { res async throws in
                    #expect(res.status == .noContent)
                })
            try await app.testing().test(
                .GET, "todos",
                afterResponse: { res async throws in
                    let left = try res.content.decode([TodoDTO].self)
                    #expect(left.isEmpty)
                })
        }
    }
}

/// Equatable for assertions in DTO comparisons (Allows DTOs to be compared directly in asserts).
extension TodoDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}
