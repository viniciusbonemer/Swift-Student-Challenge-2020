//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import PlaygroundSupport

public func instantiateZerothLiveView() -> PlaygroundLiveViewable {
    let liveViewController = ZerothViewController()
    return liveViewController
}

public func instantiateFirstLiveView() -> PlaygroundLiveViewable {
    let liveViewController = FirstViewController()
    return liveViewController
}

public func instantiateSecondLiveView() -> PlaygroundLiveViewable {
    let liveViewController = SecondViewController()
    return liveViewController
}

public func instantiateThirdLiveView() -> PlaygroundLiveViewable {
    let liveViewController = ThirdViewController()
    return liveViewController
}

public func instantiateFourthLiveView() -> PlaygroundLiveViewable {
    let liveViewController = FourthViewController()
    return liveViewController
}
