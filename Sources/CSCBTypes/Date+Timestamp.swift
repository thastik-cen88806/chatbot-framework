//
//  Date+Timestamp
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

extension Date {

    public static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970)
    }
}
