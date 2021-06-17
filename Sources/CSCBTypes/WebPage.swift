//
//  WebPage
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// WebPage
///
/// Example:
/// ========
/// ````javascript
/// {
///     "ancestorOrigins": {},
///     "hash": "#e5932cce-0705-4261-9194-3bd482aba287",
///     "host": "webchat.csast.csas.cz",
///     "hostname": "webchat.csast.csas.cz",
///     "href": "https://webchat.csast.csas.cz/#e5932cce-0705-4261-9194-3bd482aba287",
///     "origin": "https://webchat.csast.csas.cz",
///     "pageTitle": "Webchat",
///     "pathname": "/",
///     "port": "",
///     "protocol": "https:",
///     "search": ""
/// }
///````
///
public struct WebPage: Codable, AutoEquatable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case ancestorOrigins
        case hash
        case host
        case hostname
        case href
        case origin
        case pageTitle
        case pathname
        case port
        case `protocol`
        case search
    }

    // MARK: - Properties

    let ancestorOrigins: Dictionary<String, String>?
    let hash: String?
    let host: URL? // URL.Host???
    let hostname: URL? // URL.Hostname???
    let href: URL?
    let origin: URL?
    let pageTitle: String?
    let pathname: String?? // FilePath???
    let port: Int?
    let `protocol`: String?
    let search: String?

    // MARK: - Init

    public init(ancestorOrigins: Dictionary<String, String>?,
                hash: String?,
                host: URL?,
                hostname: URL?,
                href: URL?,
                origin: URL?,
                pageTitle: String?,
                pathname: String??, // FilePath???
                port: Int?,
                `protocol`: String?,
                search: String?) {

        self.ancestorOrigins = ancestorOrigins
        self.hash = hash
        self.host = host
        self.hostname = hostname
        self.href = href
        self.origin = origin
        self.pageTitle = pageTitle
        self.pathname = pathname
        self.port = port
        self.protocol = `protocol`
        self.search = search
    }
}
