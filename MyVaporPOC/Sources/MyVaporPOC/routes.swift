import Fluent
import Vapor

/// # routes
/// Registers all application endpoints, including HTML home, "hello", and the Todo API.
///
/// - Parameter app: The main Vapor `Application`.
/// - Throws: Any error from route registration or controller boot.
func routes(_ app: Application) throws {
    // Root HTML view (Home for rendered index page).
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    // GET /hello: returns a simple greeting (Health-check).
    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    // Registers all /todos API endpoints (REST/CRUD API grouped under /todos).
    try app.register(collection: TodoController())
}
