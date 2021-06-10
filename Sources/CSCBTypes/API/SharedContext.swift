//
//  SharedContext
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Context object shared between client and backend during the communication session
///
/// Example:
/// ========
/// ````javascript
/// {
///     "externalAuthorization": null,
///     "language": "cs",
///     "viewportSize": "843x634",
///     "webPage": {
///         "ancestorOrigins": {},
///         "hash": "#e5932cce-0705-4261-9194-3bd482aba287",
///         "host": "webchat.csast.csas.cz",
///         "hostname": "webchat.csast.csas.cz",
///         "href": "https://webchat.csast.csas.cz/#e5932cce-0705-4261-9194-3bd482aba287",
///         "origin": "https://webchat.csast.csas.cz",
///         "pageTitle": "Webchat",
///         "pathname": "/",
///         "port": "",
///         "protocol": "https:",
///         "search": ""
///     },
///     "webUserAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15"
/// }

public struct SharedContext: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case auth = "externalAuthorization"
        case lang = "language"
        case viewport = "viewportSize"
        case webPage
        case webUserAgent
    }

    // MARK: - Properties

    let auth: String?
    let lang: String?
    let viewport: String?
    let webPage: WebPage?
    let webUserAgent: String

    // MARK: - Init

    public init(auth: String?,
                lang: String?,
                viewport: String?,
                webPage: WebPage?,
                webUserAgent: String) {

        self.auth = auth
        self.lang = lang
        self.viewport = viewport
        self.webPage = webPage
        self.webUserAgent = webUserAgent
    }
}
