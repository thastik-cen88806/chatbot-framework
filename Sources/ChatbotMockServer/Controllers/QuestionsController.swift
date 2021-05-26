
import Fluent
import Vapor
import Leaf

struct QuestionsController: RouteCollection {

    // MARK: - Types

    struct QuestionsContext: Encodable {
        let questions: [Question]
    }

    // MARK: - Properties

    let wsController: WebSocketController

    // MARK: - Lifecycle


    /// Vapor upgrades HTTP connection to websocket and takes care of the handshake
    ///
    func boot(routes: RoutesBuilder) throws {

        routes.webSocket("socket", onUpgrade: self.webSocket)
        routes.get(use: index)
        routes.post(":questionId", "answer", use: answer)
    }

    func webSocket(req: Request, socket: WebSocket) {
        self.wsController.connect(socket)
    }

    func index(req: Request) throws -> EventLoopFuture<View> {

        Question.query(on: req.db).all().flatMap {

            return req.view.render("questions", QuestionsContext(questions: $0))
        }
    }

    func answer(req: Request) throws -> EventLoopFuture<Response> {

        guard let questionId = req.parameters.get("questionId"),
              let questionUid = UUID(questionId) else {

            throw Abort(.badRequest)
        }

        return Question
            .find(questionUid, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { question in

            question.answered = true

            return question.save(on: req.db).flatMapThrowing {

                let msg = QuestionAnsweredMessage(questionId: question.requireID())
                
                try self.wsController.send(message: msg,
                                           to: .id(question.askedFrom))

                return req.redirect(to: "/")
            }
        }
    }
}
