//
//  Postback
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

public struct Postback: Codable {

    // MARK: - TypeAliases

    public typealias AppID = Tagged<App, String>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case payload
        case appId
    }

    // MARK: - Properties

    let payload: String

    var appId: AppID?

    // MARK: - Init

    /// Postback
    ///
    /// - Parameters:
    ///   - payload: ??
    ///   - appId: ??
    ///
    public init(payload: String,
                appId: AppID?) {

        self.payload = payload

        self.appId = appId
    }
}
