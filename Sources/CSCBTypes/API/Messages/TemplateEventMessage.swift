//
//  TemplateEventMessage
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Template Event Message
///
public struct TemplateEventMessage: Codable {

    // MARK: - Properties

    let attachment: String

    // MARK: - Init

    /// Template Event Message
    ///
    /// - Parameter attachment: ???
    ///
    public init(attachment: String) {

        self.attachment = attachment
    }
}
