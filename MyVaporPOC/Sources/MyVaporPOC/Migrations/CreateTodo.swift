/// # CreateTodo
/// Async database migration for the Todo table.
/// - Adds a `todos` schema with an ID and required `title` field.

import Fluent

struct CreateTodo: AsyncMigration {
    /// Prepares (creates) the Todo table in the database.
    /// - Parameter database: The database to operate on.
    func prepare(on database: any Database) async throws {
        try await database.schema("todos")
            .id()
            .field("title", .string, .required)
            .create()
    }

    /// Reverts (removes) the Todo table.
    /// - Parameter database: The database to operate on.
    func revert(on database: any Database) async throws {
        try await database.schema("todos").delete()
    }
}
