//
//  TemplateAspectRatio
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Aspect ratio of generic template images. It's horizontal (1,91:1) by default.
///
/// UsedIn: - Template Event Message Attachment Payload
///
public enum TemplateAspectRatio: String, Codable {

    case square
    case horizontal
}
