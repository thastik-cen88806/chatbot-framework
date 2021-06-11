//
//  Init
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Init object used to start the communication
///
public struct Init: ChatMessage, Codable {

    // MARK: - TypeAliases

    public typealias IdentityID = Tagged<Identity, Int>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case `init`
        case sender
        case recipient
    }

    // MARK: - Properties

    let `init`: Dictionary<String, String>
    let sender: Sender<Tagged<Persona, String>>
    let recipient: Recipient<Tagged<Channel, String>>

    // MARK: - Init

    public init(recipient: Recipient<Tagged<Channel, String>>,
                sender: Sender<Tagged<Persona, String>>) {

        self.`init` = [:]
        self.recipient = recipient
        self.sender = sender
    }

    /// Init object used to start the communication
    ///
    /// - Parameters:
    ///   - init: empty struct (implemented as seen in webchat)
    ///   - recipient: Recipient identifier (channel or user)
    ///   - sender: Sender identifier (channel or user)
    ///
    public init(`init`: Dictionary<String, String>,
                recipient: Recipient<Tagged<Channel, String>>,
                sender: Sender<Tagged<Persona, String>>) {

        self.`init` = `init`
        self.recipient = recipient
        self.sender = sender
    }
}
