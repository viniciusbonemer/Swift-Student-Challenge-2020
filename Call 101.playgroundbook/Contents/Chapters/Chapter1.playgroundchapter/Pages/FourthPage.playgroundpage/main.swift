//#-hidden-code
import PlaygroundSupport

func startGame() {
    
    guard let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift.")
    }
    
    proxy.send(.string("start"))
}
//#-end-hidden-code
//#-code-completion(everything, hide)
/*:
 # To finish up...
 
 We just saw how our [packages](glossary://package) are not cardboard boxes, but a sequence of `0`'s and `1`'s, and we also saw how this sequence is created.
 
 But, there's still something missing: unlike the phones from the second page, our iPhones and iPads are not connected to wires... So how does this sequence of zeros and ones get to them?
 
 ## How to send data through the air
 
 Inside our devices, there is an antenna, such as a radio's one. This antenna emits vibrations of one kind for `0`s and a different one for `1`s. This way, our package is sent through the air and can be received by another antenna diferenciating between those waves.
 
 ## Last game
 
 In this last game, you will play the part of an antenna receiving these different vibrations. Your job is to decode a received [byte](glossary://byte).
 
 - Callout(How to play):
 When the wave that's passing stops in front of you, tap the button that looks like it to identify the value it represents!
 */

startGame()
