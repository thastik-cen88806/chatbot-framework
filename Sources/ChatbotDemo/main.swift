//
//  ChatbotDemo
//  ChatbotFramework
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import ChatbotFrameworkExternal
import Darwin

print(">>> start")

setbuf(stdout, nil)

guard let client = CBFrameworkExternal(url: "https://webchat.csast.csas.cz") else {

    fatalError(">>> failed url")
}

client.subject.sink { [weak self] msg in

    print(">>> msg: \(msg)")
}

let msg = CBMessage.text("ahoj")
client.send(msg)

sleep(10)
print(">>> finish")
