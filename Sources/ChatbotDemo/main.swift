//
//  ChatbotDemo
//  ChatbotFramework
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import CSCBExternal
import CSCBTypes

let sema = DispatchSemaphore(value: 0)

guard let client = try? CBFrameworkExternal(url: "https://webchat.csast.csas.cz/") else {

    fatalError(">>> failed url")
}

let json = """
{"init":{},"sender":{"id":"\(client.token?.userID ?? "NA")"},"recipient":{"id":"e5932cce-0705-4261-9194-3bd482aba287"}}
"""
let msg = CBMessage.text(json)
client.send(msg)


_ = sema.wait(timeout: .now() + 10)
