//
//  CBTypes
//  CBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

public enum CBError: Swift.Error {
    case invalidUri(url: String)
}

public enum CBMessage {

    case text(String)
    case data(Data)
}
