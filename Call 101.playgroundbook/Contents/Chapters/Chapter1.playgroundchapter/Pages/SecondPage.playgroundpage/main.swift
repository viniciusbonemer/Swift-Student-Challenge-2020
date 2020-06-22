//#-hidden-code
import PlaygroundSupport

func startGame() {
    
    guard let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift.")
    }
    
    proxy.send(.string("start"))
}
//#-end-hidden-code
/*:
 # Ok, back to the point...
 
 In the last page you saw that if when there are too many calls, we get in trouble...
 
 If one line stays occupied for too much time, other people can't talk to who they want to.
 On the internet, we know that there are a lot of people connected in the same time. So how do we do it?
 
 ## How do we make connections on the internet
 
 The solution to this problem is to split a message in several small pieces. We call one of those pieces a **[package](glossary://package)**, and when we put together all the packages that you want send, we have a **[message](glossary://message)**.
 
 Now, we don't keep a wire connected during the whole time we are exchanging messages. We do three things:
 1. Connect
 2. Send one package
 3. Disconnect
 
 It's like each package is a box with a destination, and this box is going through the mail. On each stop, we only need to send it to the next stop, until it finally reaches it's destination.
 
 ## Game!
 
 In this next game, each box is a piece of a message that someone is receiving. Help send the boxes to the right place to complete the messages!
 
 * Callout(How to play):
 When a package arrives, drag it to the correct treadmill on the right.
 
 That's it!
 
 - Note: Hit run my code when you are ready to start the game.
 
 
 */
//#-code-completion(everything, hide)

startGame()
