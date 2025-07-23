/// # Todo
/// Represents a Todo model entity stored in the SQLite database.
/// - Stores a unique ID and a title.
/// - Implements Vapor's `Model` with Fluent ORM.

import Fluent

import struct Foundation.UUID

final class Todo: Model, @unchecked Sendable {
    /// The schema name in the database.
    static let schema = "todos"

    /// The unique identifier for the Todo item.
    @ID(key: .id)
    var id: UUID?

    /// The title/description of the Todo.
    @Field(key: "title")
    var title: String

    /// Empty initializer for Fluent.
    init() {}

    /// Designated initializer for creating a Todo instance.
    /// - Parameters:
    ///   - id: Optional UUID for the Todo. Usually auto-set.
    ///   - title: The text for the Todo.
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }

    /// Converts this model into a DTO used for API communication.
    /// - Returns: A `TodoDTO` representing this Todo for API responses.
    func toDTO() -> TodoDTO {
        .init(id: self.id, title: self.title)
    }
}
