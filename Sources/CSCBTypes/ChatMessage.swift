//
//  ChatMessage
//  CBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Protocol marking all types able to be converted to JSON and thus sendable by the framework
///
public protocol ChatMessage: Codable {}

public enum Object: Decodable {

    // MARK: - TypeAliases

    public typealias ChannelID = Tagged<Channel, String>
    public typealias UserID = Tagged<Persona, String>

    case typing(TypingEvent<ChannelID, UserID>)
    case message(TextMessageEvent<ChannelID, UserID>)
    case unknown

    public init(from decoder: Decoder) throws {

        let objectContainer = try decoder.singleValueContainer()

        if let typingContainer = try? decoder.container(keyedBy: TypingEvent<ChannelID, UserID>.CodingKeys.self) {

            let obj = try objectContainer.decode(TypingEvent<ChannelID, UserID>.self)
            self = .typing(obj)
        }

        if let messageContainer = try? decoder.container(keyedBy: TextMessageEvent<ChannelID, UserID>.CodingKeys.self) {

            let obj = try objectContainer.decode(TextMessageEvent<ChannelID, UserID>.self)
            self = .message(obj)
        }

        self = .unknown
    }
}
