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
 # First, let's go back a little...
 
 To understand how FaceTime works, it will be easier if we start talking about the first landline phones.

 ## How a landline phone works
 
 To talk to someone, a wire needs to be connected from your phone to the other person's phone. When this happens, everything you say go through the wire until it reaches someone's ear!
 
 - Note: Actually, your phone stays connected to a telephone switchboard and the switchboard operator connects your calls.
 
 ## Our first game
 
 In this game on the right, you are going to act as a switchboard operator. Your job is to help people talk to one another by connecting their calls.
 
 - Callout(How to play):
 When a phone starts calling, use a drag gesture to connect it's call!
 
 Simple, right?
 
 - Note: Hit run my code when you are ready to start the game. 


 */
//#-code-completion(everything, hide)

startGame()
