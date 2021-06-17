import Foundation
import PlaygroundSupport
import CSCBTypes
import Tagged

let channelID: Tagged<Channel, String> = "e5932cce-0705-4261-9194-3bd482aba287"
let channelID2: Tagged<Channel, String> = "e5932cce-0705-4261-9194-3bd482aba287"

let personaID: Tagged<Persona, String> = "e5932cce-0705-4261-9194-3bd482aba287"

print(channelID == channelID2)
//print(channelID == personaID)

let rec = Recipient(id: channelID)
let rec2 = Recipient(id: channelID2)

print(rec == rec2)
//: [Previous](@previous)                                                      [Next](@next)
