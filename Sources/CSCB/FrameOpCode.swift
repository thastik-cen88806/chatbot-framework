//
//  FrameOpCode
//  CSCB
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// type of websocket frame to be sent
///
/// Note: - ranges 3-7 & B-F are reserved
///
public enum FrameOpCode: UInt8 {

    case continueFrame = 0x0
    case textFrame = 0x1
    case binaryFrame = 0x2
    case connectionClose = 0x8
    case ping = 0x9
    case pong = 0xA
    case unknown = 100
}
