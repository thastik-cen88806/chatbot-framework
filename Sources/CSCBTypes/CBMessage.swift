//
//  CBMessage
//  CBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// envelope object able to be sent via websocket
///
public enum CBMessage {

    case text(String)
    case data(Data)
}
