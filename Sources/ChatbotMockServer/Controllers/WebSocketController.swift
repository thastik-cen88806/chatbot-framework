
import Vapor
import Fluent

enum WebSocketSendOption {

    case id(UUID)
    case socket(WebSocket)
}

final class WebSocketController {

    // MARK: - Properties

    let lock: Lock
    var sockets: [UUID: WebSocket]
    let db: Database
    let logger: Logger

    // MARK: - Init

    init(db: Database) {

        self.lock = Lock()
        self.sockets = [:]
        self.db = db
        self.logger = Logger(label: "WebSocketController")
    }

    // MARK: - Lifecycle

    func connect(_ ws: WebSocket) {

        let uuid = UUID()

        self.lock.withLockVoid {
            self.sockets[uuid] = ws
        }

        ws.onBinary { [weak self] ws, buffer in

            guard let self = self,
                  let data = buffer.getData(at: buffer.readerIndex,
                                            length: buffer.readableBytes) else {

                return
            }

            self.onData(ws, data)
        }

        ws.onText { [weak self] ws, text in

            guard let self = self,
                  let data = text.data(using: .utf8) else {

                return
            }

            self.onData(ws, data)
        }

        self.send(message: QnAHandshake(id: uuid), to: .socket(ws))
    }

    func send<T: Codable>(message: T, to sendOption: WebSocketSendOption) {

        logger.info("Sending \(T.self) to \(sendOption)")

        do {

            let sockets: [WebSocket] = self.lock.withLock {

                switch sendOption {

                    case let .id(id):

                        return [self.sockets[id]].compactMap { $0 }

                    case let .socket(socket):

                        return [socket]
                }
            }

            let encoder = JSONEncoder()
            let data = try encoder.encode(message)

            sockets.forEach {
                $0.send(raw: data, opcode: .binary)
            }
        } catch {
            logger.report(error: error)
        }
    }

    func onNewQuestion(_ ws: WebSocket, _ id: UUID, _ message: NewQuestionMessage) {

        let q = Question(content: message.content, askedFrom: id)

        self.db.withConnection {
            q.save(on: $0)
        }.whenComplete { res in

            let success: Bool
            let message: String

            switch res {

                case let .failure(err):

                    self.logger.report(error: err)
                    success = false
                    message = "Something went wrong creating the question."

                case .success:

                    self.logger.info("Got a new question!")
                    success = true
                    message = "Question created. We will answer it as soon as possible :]"
            }

            let id = try! q.requireID()
            let msg = NewQuestionResponse(success: success,
                                          message: message,
                                          id: id,
                                          answered: q.answered,
                                          content: q.content,
                                          createdAt: q.createdAt)

            self.send(message: msg, to: .socket(ws))
        }
    }

    func onData(_ ws: WebSocket, _ data: Data) {

        let decoder = JSONDecoder()

        do {

            let sinData = try decoder.decode(QnAMessageSinData.self, from: data)

            switch sinData.type {

                case .newQuestion:

                    let newQuestionData = try decoder.decode(NewQuestionMessage.self,
                                                             from: data)
                    self.onNewQuestion(ws, sinData.id, newQuestionData)

                default:

                    break
            }
        } catch {
            logger.report(error: error)
        }
    }
}
