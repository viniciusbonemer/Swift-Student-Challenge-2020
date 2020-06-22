# Swift-Student-Challenge-2020

My (**accepted**) submission for the Swift Student Challenge 2020. 

You can also see the [video on YouTube](https://youtu.be/PBUt_Ra_MH8). 

In this Swift Student Challenge, I wanted to make people wonder and learn about something they don’t fully understand, and are in constant contact with — FaceTime.

This repository contains a PlaygroundBook designed to work with Playgrounds on macOS and some Processing code to create one animation used in the playground. 

Keep in mind that this was created in a few days and isn't going to be maintained, so my foccus was speed over code quality. 

The first and last pages of my playground use modified code from Nathan Gitter's [Building Fluid Interfaces](https://github.com/nathangitter/fluid-interfaces) project. 

## Essay: Tell us about the features and technologies you used in your Swift playground

During my whole life, I’ve always loved to understand how things worked. I remember the day I asked my father about how come the light goes on when I flick a switch — for me, as a child, this just seemed like magic. He paused and started explaining about switches and power stations. But these concepts are pretty hard, as child, to wrap your head around. So, finally, he bought a PVC pipe and some wires and built a lamp with me, so I could see the things he was talking about. 

In this Swift Challenge, I wanted to give people a hands-on experience like the one I had that day. Given that people all around the world are working and meeting friends without leaving their homes using video calls, I took the opportunity to make them wonder and learn about something they are constantly in contact with — FaceTime. 

This is a really complex theme. So, to start, I wanted to make people understand how information is transmitted on the internet, and to do that, I decided to first explain how landline phones worked. This would make the reader understand the problems that come with having to have two devices physically connected in order to communicate. After that, it becomes much more logical to explain the internet. 

The first game, about phones, was built using UIKit. I used Autolayout to position my views, a little bit of CoreGraphics and CoreAnimation for the animations, and AVPlayers for the sounds. This project was built from day one on Playgrounds, which allowed me to quickly test what I was doing. 

The second game was created in SpriteKit. The framework is just great and allowed me to get an even better result with less time and effort. I really liked how easy it was to animate the colors changing to give feedback to the user while he dragged the boxes from one treadmill to the next. 

The next page was originally not in my plans, but testing my interactions with other people I realised that they didn’t understand how information is represented in binary form. So, I created an animation to illustrate the conversion of an image to a sequence of bytes. Unfortunately, I didn’t have enough time to learn how to create this animation using CoreAnimation or SpriteKit, so I opted for coding it in Processing and importing the video as a resource. I swear I missed Swift every step of the way! 

For the last page I used UIKit and SpriteKit for the graphics, and Combine to pass data from one place to another in a simple manner. 

Before I even started coding, I created prototypes and tested with people from my family who are not from a technology background. As I implemented the code, I went back and tested again. This gave me the confidence that what I developed can be understood by no matter who. So I hope this also makes you wonder about the things you can still discover. 
