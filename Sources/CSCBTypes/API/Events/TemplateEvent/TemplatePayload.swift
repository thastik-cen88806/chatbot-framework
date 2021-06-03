//
//  TemplatePayload
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Template Payload
///
public struct TemplatePayload: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case templateType = "template_type"
        case text
        case buttons
        case imgAspectRatio = "image_aspect_ratio"
        case elements
    }

    enum TemplatePayloadError: Error {

        case textLengthOverflow(String)
        case arrayElementsOverflow(String)
    }

    // MARK: - Properties

    static let buttonArrayError = "there can be up to \(TemplatePayload.maxArrayElements) entries in buttons `Array`"
    static let elementsArrayError = "there can be up to \(TemplatePayload.maxArrayElements) entries in elements `Array`"
    static let textLengthError = "there can be up to \(TemplatePayload.maxTextLength) characters in text"

    static let maxArrayElements = 10
    static let maxTextLength = 640

    let templateType: GenericType

    var text: String?
    var buttons: Array<Button>?
    var imgAspectRatio: TemplateAspectRatio?
    var elements: Array<GenericTemplate>?

    // MARK: - Init

    /// Template Payload
    ///
    /// - Parameters:
    ///   - templateType: Type of template
    ///   - text: Text of max 640 characters (required in button template)
    ///   - buttons: Array of max 10 buttons (required in button template)
    ///   - imgAspectRatio: Aspect ratio of generic template images. default: horizontal (1,91:1)
    ///   - elements: Array of max 10 buttons (required in generic template)
    ///
    /// - Throws:
    ///   - error: TemplatePayloadError.textLengthOverflow(<error description>)
    ///   - error: TemplatePayloadError.arrayElementsOverflow(<error description>)
    ///
    public init(templateType: GenericType,
                text: String?,
                buttons: Array<Button>?,
                imgAspectRatio: TemplateAspectRatio?,
                elements: Array<GenericTemplate>?) throws {

        if let chars = text {
            guard chars.count < TemplatePayload.maxTextLength else {
                throw TemplatePayloadError.textLengthOverflow(TemplatePayload.buttonArrayError)
            }
        }

        if let btnz = buttons {
            guard btnz.count < TemplatePayload.maxArrayElements else {
                throw TemplatePayloadError.arrayElementsOverflow(TemplatePayload.buttonArrayError)
            }
        }

        if let elms = elements {
            guard elms.count < TemplatePayload.maxArrayElements else {
                throw TemplatePayloadError.arrayElementsOverflow(TemplatePayload.elementsArrayError)
            }
        }

        self.templateType = templateType
        self.text = text
        self.buttons = buttons
        self.imgAspectRatio = imgAspectRatio
        self.elements = elements
    }
}
