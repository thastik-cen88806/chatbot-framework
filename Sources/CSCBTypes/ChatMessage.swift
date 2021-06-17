//
//  ChatMessage
//  CBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Object hodling all types able to be converted to JSON and thus sendable by the framework
///
public enum ChatMessage: AutoEquatable, AutoCaseName {

    // MARK: - TypeAliases

    public typealias ChannelID = Tagged<Channel, String>
    public typealias UserID = Tagged<Persona, String>

    case `init`(Init)
    case start(Start)
    case pong(Pong)
    case typing(TypingEvent<ChannelID, UserID>)
    case message(TextMessageEvent<ChannelID, UserID>)
    case quickReply(QuickReplyMessageEvent<ChannelID, UserID>)
    case unknown
}

// MARK: - Decodable

extension ChatMessage: Decodable {

    public init(from decoder: Decoder) throws {

        let objectContainer = try decoder.singleValueContainer()

        if let obj = try? objectContainer.decode(Init.self) {
            self = .`init`(obj)
            return
        }

        if let obj = try? objectContainer.decode(Start.self) {
            self = .start(obj)
            return
        }

        if let obj = try? objectContainer.decode(TypingEvent<ChannelID, UserID>.self) {
            self = .typing(obj)
            return
        }

        if let obj = try? objectContainer.decode(TextMessageEvent<ChannelID, UserID>.self) {
            self = .message(obj)
            return
        }

        if let obj = try? objectContainer.decode(QuickReplyMessageEvent<ChannelID, UserID>.self) {
            self = .quickReply(obj)
            return
        }

//        self.logger.warning("turn on debug logging to see underlying json")
        self = .unknown
    }
}

// MARK: - Encodable

extension ChatMessage: Encodable {

    public func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()

        switch self {

            case let .`init`(obj): try container.encode(obj)

            case let .start(obj): try container.encode(obj)

            case let .pong(obj): try container.encode(obj)

            case let .typing(obj): try container.encode(obj)

            case let .message(obj): try container.encode(obj)

            case let .quickReply(obj): try container.encode(obj)

            case .unknown:

                let context = EncodingError.Context(codingPath: [], debugDescription: "ne-E not sending that")
                throw EncodingError.invalidValue(Self.unknown, context)
        }
    }
}
