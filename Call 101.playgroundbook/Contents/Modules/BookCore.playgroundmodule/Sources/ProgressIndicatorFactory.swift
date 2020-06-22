//
//  ProgressIndicatorFactory.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 14/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public enum ProgressIndicatorFactory {
    
    private static var progressIndicatorRadius: CGFloat { 40 }
    
    private static var progressIndicatorDeltaY: CGFloat { 110 }
    
    private static var progressIndicatorDeltaX: CGFloat { 120 }
    
    public static func createProgressIndicator(for treadmill: Treadmill) -> TreadmillProgressIndicator {
        let showX = treadmill.position.x - treadmill.size.width / 2
        let showY = treadmill.position.y + Self.progressIndicatorDeltaY
        let showPos = CGPoint(x: showX, y: showY)
        
        let hideX = treadmill.position.x + 2 * Self.progressIndicatorRadius
        let hideY = showY
        let hidePos = CGPoint(x: hideX, y: hideY)
        
        let indicator = TreadmillProgressIndicator(radius: Self.progressIndicatorRadius,
                                          color: treadmill.customColor,
                                          showPosition: showPos, hidePosition: hidePos)
        indicator.setProgress(0.01, animated: false)
        
        return indicator
    }
    
}
