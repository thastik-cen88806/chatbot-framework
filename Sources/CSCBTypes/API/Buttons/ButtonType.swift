//
//  ButtonType
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Button type (postback or web_url)
///
/// UsedIn: - Template Event Message Attachment Payload
///
public enum ButtonType: String, Codable {

    case postback
    case weburl = "web_url"
}
