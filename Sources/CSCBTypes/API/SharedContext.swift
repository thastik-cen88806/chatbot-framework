//
//  SharedContext
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

public struct SharedContext: Codable {

    // MARK: - Properties

    let webUserAgent: String

    // MARK: - Init

    public init(webUserAgent: String) {

        self.webUserAgent = webUserAgent
    }
}
