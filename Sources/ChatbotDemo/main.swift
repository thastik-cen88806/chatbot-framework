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

let channelID: Tagged<Channel, String> = "e5932cce-0705-4261-9194-3bd482aba287"

guard let client = try? CBFramework(url: "https://webchat.csast.csas.cz/") else {

    fatalError(">>> failed url")
}

sleep(3)

guard let senderID = client.token?.userID else {
    fatalError(">>> failed senderID")
}

let sender = Sender(id: senderID)
let recipient = Recipient(id: channelID)

let json = Init(recipient: recipient, sender: sender)

try? client.send(json)

sleep(1)

let start = Start(recipient: recipient, sender: sender)

print(start)

try? client.send(start)

_ = sema.wait(timeout: .now() + 10)
