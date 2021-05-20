
import Fluent
import Vapor

final class Question: Model, Content {

    static let schema = "questions"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "content")
    var content: String

    @Field(key: "answered")
    var answered: Bool

    @Field(key: "asked_from")
    var askedFrom: UUID

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, content: String, askedFrom: UUID) {
        
        self.id = id
        self.content = content
        self.answered = false
        self.askedFrom = askedFrom
    }
}
