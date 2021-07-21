import PlaygroundSupport
import SwiftUI
//import CSCB
//import CSCBTypes

struct ContentView: View {

//    @StateObject var data = BotModel()

    var body: some View {
        VStack {
            MessageView(contentMessage: "Hello from George", isCurrentUser: false)
            MessageView(contentMessage: "Help with account", isCurrentUser: true)
        }
        .padding(.horizontal, 15)
    }
}

struct MessageView: View {

    var contentMessage: String
    var isCurrentUser: Bool

    var body: some View {
        VStack {
            HStack {
                if isCurrentUser {
                    Spacer()
                }
                Text(contentMessage)
                    .padding(10)
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .background(isCurrentUser ? Color(UIColor.systemBlue) : Color(UIColor.systemGreen))
                    .clipShape(Capsule())
                if !isCurrentUser {
                    Spacer()
                }
            }
            .padding(isCurrentUser ? .leading : .trailing, 55)
            .padding(.vertical, 10)
        }
    }
}

//final class BotModel: ObservableObject {
//
//    @Published var msgs: [ChatMessage] = []
//    var framework: CBFramework?
//
//    func onAppear() {
//        print(">>> YO")
//        do {
//            self.framework = try CBFramework()
//        } catch {
//            print(">>> error \(error)")
//        }
//    }
//}

PlaygroundPage.current.setLiveView(ContentView())

//: [Previous](@previous)                                                      [Next](@next)
