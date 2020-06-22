/*:
 # Welcome to Call 101!
 
 We are living a really different moment in human history... All around the World people have been staying at home for weeks, but even without moving, they keep talking, working and even *meeting*.
 
 This, of course, is only possible thanks to **technology**.
 
 ## But how?
 
 Have you ever stoped and wondered how can we do it? How can we see instantly someone who is so far away? In this Playground, we are going to explore some of the steps necessary to make something like FaceTime work!
 
 We have a lot to see, so, when you are ready, let's start on the [**Next page**](@next)!
 */
//#-code-completion(everything, hide)

//#-hidden-code
import PlaygroundSupport

let message = "### Ready to start? "
let link = "\n\n[**Next page**](@next)"
PlaygroundPage.current.assessmentStatus = .pass(message: "\(message)\(link)")

//#-end-hidden-code
