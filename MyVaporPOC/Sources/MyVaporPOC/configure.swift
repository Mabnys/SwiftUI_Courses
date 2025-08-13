/// # Application Configuration (configure.swift)
/// Sets up DB, migrations, templating, and routes.
/// - For `.testing`: Uses in-memory SQLite for test isolation.
/// - For other: Uses file DB for persistence.
/// - Always sets up `CreateTodo` migration and all routes, and auto-migrates at startup.
///
import Fluent
import FluentSQLiteDriver
import Leaf
import NIOSSL
import Vapor

/// Configures your Vapor application.
///
/// - Parameters:
///   - app: The main Vapor `Application` object.
/// - Throws: Any error that prevents configuration from completing.
/// - Important:
///   - Uses in-memory SQLite for `.testing` to support isolated, fast backend CI/CD tests.
///   - Uses file-backed SQLite by default for development and production.
public func configure(_ app: Application) async throws {
    // Uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    /// Database configuration:
    /// - For tests, use an in-memory DB (`.sqlite(.memory)`)
    /// - Elsewhere, use persistent DB
    if app.environment == .testing {
        // Use in-memory SQLite for unit and integration tests
        app.databases.use(.sqlite(.memory), as: .sqlite)
    } else {
        // Use a file-based SQLite database for development or production
        app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
    }

    /// Model and entity migrations (run in all environments)
    app.migrations.add(CreateTodo())

    /// Register the Leaf view renderer
    app.views.use(.leaf)

    // After registering migrations
    try await app.autoMigrate()

    /// Register HTTP and API routes
    try routes(app)

}
