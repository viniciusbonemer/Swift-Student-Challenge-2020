//#-hidden-code
import PlaygroundSupport

func startConversion() {
    
    guard let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift.")
    }
    
    proxy.send(.string("start"))
}
//#-end-hidden-code
//#-code-completion(everything, hide)
/*:
 # Some details...
 
 Now, we already know how the [messages](glossary://message) we want to send through the internet are broken into pieces and go through wires until they reach the correct place.
 
 But how do we transform a video into a [package](glossary://package)?
 
 We know that the packages we are talking about are not actual cardboard boxes... In fact, they are just a sequence of `0`'s and `1`'s. But that is not much help... How do we turn a video into zeros and ones?
 
  ## How to convert data
 
 In the exemple shown here, a frame of our video is going through this transformation. You can tap Run my Code to watch it happening.
 */

startConversion()

/*:
 
 To do this, we will take the color of each [pixel](glossary://pixel) and arrange them one after the other. Then, we are going to represent each color as a number, and write this number in it's [binary form](glossary://binary).
 
 Now, we have a real package.
 
 - Note: We are reducing the number of pixels of the image to make it easier to see what's going on.
 The final image has the same colors of the bar that shows up below.
 
 When you feel more confortable with this conversion, you can go to the next page.
 */
