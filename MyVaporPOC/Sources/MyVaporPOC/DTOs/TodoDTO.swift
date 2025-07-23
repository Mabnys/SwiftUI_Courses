/// # TodoDTO
/// Data Transfer Object for Todo used in API communication.
/// - Supports encoding/decoding with Vapor's `Content` protocol.

import Fluent
import Vapor

struct TodoDTO: Content {
    /// Unique identifier for the Todo, optional as new items may not have it yet.
    var id: UUID?
    /// The human-readable title of the Todo.
    var title: String?

    /// Converts this DTO to a `Todo` Fluent model.
    /// - Returns: `Todo` instance suitable for database operations.
    func toModel() -> Todo {
        let model = Todo()
        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        return model
    }
}
