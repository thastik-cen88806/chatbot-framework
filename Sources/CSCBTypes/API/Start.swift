//
//  Start
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Start object used to start the communication
///
/// Example:
/// ========
///````javascript
/// {
///     "mid": "3WmQ032kXXJ7.e5932cce-0705-4261-9194-3bd482aba287.SZvKOAh.3c6N0NR",
///     "postback": {
///         "appId": null,
///         "payload": "start"
///     },
///     "recipient": {
///         "id": "e5932cce-0705-4261-9194-3bd482aba287"
///     },
///     "sender": {
///         "id": "3WmQ032kXXJ7"
///     },
///     "setSharedContext": {
///         "externalAuthorization": null,
///         "language": "cs",
///         "viewportSize": "843x634",
///         "webPage": {
///             "ancestorOrigins": {},
///             "hash": "#e5932cce-0705-4261-9194-3bd482aba287",
///             "host": "webchat.csast.csas.cz",
///             "hostname": "webchat.csast.csas.cz",
///             "href": "https://webchat.csast.csas.cz/#e5932cce-0705-4261-9194-3bd482aba287",
///             "origin": "https://webchat.csast.csas.cz",
///             "pageTitle": "Webchat",
///             "pathname": "/",
///             "port": "",
///             "protocol": "https:",
///             "search": ""
///         },
///         "webUserAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15"
///     },
///     "timestamp": 1623318356103
/// }
/// ````
///
public struct Start: ChatMessage, Codable {

    // MARK: - TypeAliases

    public typealias IdentityID = Tagged<Identity, Int>
    public typealias Timestamp = Tagged<Stamp, Int64>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case messageId = "mid"
        case postback
        case recipient
        case sender
        case context = "setSharedContext"
        case timestamp
    }

    // MARK: - Properties

    let messageId: String
    let postback: Postback
    let recipient: Recipient<Tagged<Channel, String>>
    let sender: Sender<Tagged<Persona, String>>
    let context: SharedContext
    let timestamp: Timestamp

    // MARK: - Init

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - messageId: <#messageId description#>
    ///   - postback: <#postback description#>
    ///   - recipient: <#recipient description#>
    ///   - sender: <#sender description#>
    ///   - context: <#context description#>
    ///   - timestamp: <#timestamp description#>
    ///
    public init(messageId: String,
                postback: Postback,
                recipient: Recipient<Tagged<Channel, String>>,
                sender: Sender<Tagged<Persona, String>>,
                context: SharedContext,
                timestamp: Timestamp) {

        self.messageId = messageId
        self.postback = postback
        self.recipient = recipient
        self.sender = sender
        self.context = context
        self.timestamp = timestamp
    }
}
