//
//  Postback
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

public struct Postback: Codable {

    // MARK: - Properties

    let payload: String
    var appId: String?

    // MARK: - Init

    public init(payload: String, appId: String?) {

        self.payload = payload
        self.appId = appId
    }
}
