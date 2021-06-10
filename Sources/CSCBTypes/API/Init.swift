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

    /// Init object used to start the communication
    ///
    /// - Parameters:
    ///   - init: empty struct (implemented as seen in webchat)
    ///   - sender: Sender identifier (channel or user)
    ///   - recipient: Recipient identifier (channel or user)
    ///
    public init(`init`: Dictionary<String, String>,
                sender: Sender<Tagged<Persona, String>>,
                recipient: Recipient<Tagged<Channel, String>>) {

        self.`init` = `init`
        self.sender = sender
        self.recipient = recipient
    }
}
