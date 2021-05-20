
import Fluent

struct CreateQuestion: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {

        return database.schema(Question.schema)
            .id()
            .field("content", .string, .required)
            .field("answered", .bool, .required, .sql(.default(false)))
            .field("asked_from", .uuid, .required)
            .field("created_at", .date)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Question.schema).delete()
    }
}
