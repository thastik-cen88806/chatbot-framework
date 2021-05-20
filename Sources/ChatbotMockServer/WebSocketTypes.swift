
import Foundation

enum QnAMessageType: String, Codable {

    case newQuestion
    case questionResponse, handshake, questionAnswer
}

struct QnAMessageSinData: Codable {

    let type: QnAMessageType
    let id: UUID
}

struct QnAHandshake: Codable {

    var type = QnAMessageType.handshake
    let id: UUID
}

struct NewQuestionMessage: Codable {
    let content: String
}

struct NewQuestionResponse: Codable {

    var type = QnAMessageType.questionResponse
    let success: Bool
    let message: String
    let id: UUID?
    let answered: Bool
    let content: String
    let createdAt: Date?
}

struct QuestionAnsweredMessage: Codable {

    var type = QnAMessageType.questionAnswer
    let questionId: UUID
}
