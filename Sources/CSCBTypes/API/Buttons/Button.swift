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
//public struct Button: Codable {
//
//    // MARK: - Types
//
//    enum CodingKeys: String, CodingKey {
//
//        case type = "type"
//        case title
//        case payload
//        case url
//    }
//
//    // MARK: - Properties
//
//    let type: ButtonType
//    let title: String
//
//    var payload: String?
//    var url: String?
//
//    // MARK: - Init
//
//    /// Button
//    ///
//    /// - Parameters:
//    ///   - type: Button type (postback or web_url)
//    ///   - title: Button title - maxLength: 20
//    ///   - payload: Required for postback button - maxLength: 1000
//    ///   - url: Required for web_url button - maxLength: 1000
//    ///
//    public init(type: ButtonType,
//                title: String,
//                payload: String?,
//                url: String?) {
//
//        self.type = type
//        self.title = title
//        self.payload = payload
//        self.url = url
//    }
//}
