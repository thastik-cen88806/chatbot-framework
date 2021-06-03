//
//  Button
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Button
///
public struct Button: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case title
        case payload
        case url
    }

    // MARK: - Properties

    static let urlLengthError = "there can be up to \(Button.maxStringLength) characters in url"
    static let payloadLengthError = "there can be up to \(Button.maxStringLength) characters in payload"
    static let titleLengthError = "there can be up to \(Button.maxTitleLength) characters in title"

    static let maxStringLength = 1000
    static let maxTitleLength = 20

    let type: ButtonType
    let title: String

    var payload: String?
    var url: URL?

    // MARK: - Init

    /// Button
    ///
    /// - Parameters:
    ///   - type: Button type (postback or web_url)
    ///   - title: Text of max 20 characters
    ///   - payload: Text of max 1000 characters (required in postback of button template)
    ///   - url: Text of max 1000 characters (required in web_url button)
    ///
    /// - Throws: ButtonError.textLengthOverflow(<error description>)
    ///
    public init(type: ButtonType,
                title: String,
                payload: String?,
                url: URL?) throws {

        guard title.count < Button.maxTitleLength else {
            throw CBError.textLengthOverflow(text: Button.titleLengthError)
        }

        if let pld = payload {
            guard pld.count < Button.maxStringLength else {
                throw CBError.textLengthOverflow(text: Button.payloadLengthError)
            }
        }

        if let uri = url?.absoluteString {
            guard uri.count < Button.maxStringLength else {
                throw CBError.textLengthOverflow(text: Button.urlLengthError)
            }
        }

        self.type = type
        self.title = title

        self.payload = payload
        self.url = url
    }
}
