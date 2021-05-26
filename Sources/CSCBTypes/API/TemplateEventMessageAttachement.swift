//
//  TemplateEventMessage
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Template Event Message Attachment
///
public struct TemplateEventMessageAttachement: Codable {

    // MARK: - Properties

    let type: String
    let payload: Array<QuickReply>

    // MARK: - Init

    public init(type: String,
                payload: Array<QuickReply> = []) {

        self.type = type
        self.payload = payload
    }
}
