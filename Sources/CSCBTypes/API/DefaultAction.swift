//
//  DefaultAction
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Opens an URL, when user clicks the card
///
public struct DefaultAction: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case type
        case url
        case webviewHeightRatio = "webview_height_ratio"
    }

    // MARK: - Properties

    let type: ButtonType = .weburl
    let url: String

    var webviewHeightRatio: String?

    // MARK: - Init

    /// Generic template item
    ///
    /// - Parameters:
    ///   - url: Url to open
    ///   - webviewHeightRatio: example: tall
    ///
    public init(url: String,
                webviewHeightRatio: String?) {

        self.url = url
        
        self.webviewHeightRatio = webviewHeightRatio
    }
}
