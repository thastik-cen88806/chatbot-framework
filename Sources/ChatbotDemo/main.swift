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

/**
 jwt mock
let msg2 = JWTToken().jwt
print(">>> token: \(msg2)")
 guard let client = try? CBFrameworkExternal(url: "https://webchat.csast.csas.cz/?token=\(msg2)") else {
 */

guard let client = try? CBFrameworkExternal(url: "wss://webchat.csast.csas.cz") else {

    fatalError(">>> failed url")
}

let cancellable = client.subject.sink { msg in

    print(">>> msg: \(msg)")
}

/**
let emsg = TextMessage(recipient: Recipient(id: "deadbeef"), message: Message(text: "deaddead"))

let jsonData = try! JSONEncoder().encode(emsg)
let jsonString = String(data: jsonData, encoding: .utf8)!

print(">>> json: \(jsonString)")
 */
let msg = CBMessage.text("jsonString")
client.send(msg)

sleep(10)
print(">>> finish")
