// Generated using Sourcery 1.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



// MARK: - CBError

extension CBError {

    enum CaseName: String {

        case arrayElementsOverflow

        case invalidUri

        case networkTimeout

        case textLengthOverflow

        case tokenZeroDecode

        case tokenZeroHTMLExtract

        case tokenZeroDataDecoding

        case tokenZeroNoHTMLData

        case tokenJWTMissingExpiration

        case tokenJWTExpired

        case regexFormat

        case regexNoMatch

    }

    var caseName: CaseName {

        switch self {

            case .arrayElementsOverflow: return .arrayElementsOverflow

            case .invalidUri: return .invalidUri

            case .networkTimeout: return .networkTimeout

            case .textLengthOverflow: return .textLengthOverflow

            case .tokenZeroDecode: return .tokenZeroDecode

            case .tokenZeroHTMLExtract: return .tokenZeroHTMLExtract

            case .tokenZeroDataDecoding: return .tokenZeroDataDecoding

            case .tokenZeroNoHTMLData: return .tokenZeroNoHTMLData

            case .tokenJWTMissingExpiration: return .tokenJWTMissingExpiration

            case .tokenJWTExpired: return .tokenJWTExpired

            case .regexFormat: return .regexFormat

            case .regexNoMatch: return .regexNoMatch

        }
    }
}


// MARK: - ChatMessage

extension ChatMessage {

    enum CaseName: String {

        case `init`

        case start

        case pong

        case typing

        case message

        case quickReply

        case unknown

    }

    var caseName: CaseName {

        switch self {

            case .`init`: return .`init`

            case .start: return .start

            case .pong: return .pong

            case .typing: return .typing

            case .message: return .message

            case .quickReply: return .quickReply

            case .unknown: return .unknown

        }
    }
}

