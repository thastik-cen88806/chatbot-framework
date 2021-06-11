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
import Tagged

let sema = DispatchSemaphore(value: 0)

guard let client = try? CBFramework(url: "https://webchat.csast.csas.cz/") else {

    fatalError(">>> failed url")
}

_ = sema.wait(timeout: .now() + 10)
