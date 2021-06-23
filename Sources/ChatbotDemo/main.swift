//
//  ChatbotDemo
//  ChatbotFramework
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import CSCB
import CSCBTypes

let sema = DispatchSemaphore(value: 0)

do {
    let client = try CBFramework()
} catch {
    print(">>> error \(error)")
}

_ = sema.wait(timeout: .now() + 10)
