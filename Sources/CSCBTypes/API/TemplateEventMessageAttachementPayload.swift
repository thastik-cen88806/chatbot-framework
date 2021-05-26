//
//  TemplateType
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Template Event Message Attachment Payload
///
//public struct TemplateEventMessageAttachementPayload: Codable {
//
//    // MARK: - Types
//
//    enum CodingKeys: String, CodingKey {
//
//        case templateType = "template_type"
//        case text
//        case buttons
//        case imgAspectRatio = "image_aspect_ratio"
//        case elements
//    }
//
//    // MARK: - Properties
//
//    let templateType: TemplateType
//
//    var text: String?
//    var buttons: Array<Button>?
//    var imgAspectRatio: IMGAspectRatio?
//    var elements: Array<GenericTemplate>?
//
//    // MARK: - Init
//
//    /// Template Event Message Attachment Payload
//    ///
//    ///
//    /// - Parameters:
//    ///   - templateType: Type of template
//    ///   - text: Text (required in button template)
//    ///   - buttons: List of max 10 buttons (required in button template)
//    ///   - imgAspectRatio: Aspect ratio of generic template images. It's horizontal (1,91:1) by default
//    ///   - elements: Up to 10 elements of generic template (required in generic template)
//    ///
//    public init(templateType: TemplateType,
//                text: String?,
//                buttons: Array<Button>?,
//                imgAspectRatio: IMGAspectRatio?,
//                elements: Array<GenericTemplate>?) {
//
//        self.templateType = templateType
//        self.text = text
//        self.buttons = buttons
//        self.imgAspectRatio = imgAspectRatio
//        self.elements = elements
//    }
//}
