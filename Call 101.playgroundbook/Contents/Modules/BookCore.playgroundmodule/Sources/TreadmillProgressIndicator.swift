//
//  TreadmillProgressIndicator.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 14/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public class TreadmillProgressIndicator: ProgressNode {
    
    private static var moveActionDuration: TimeInterval { 0.3 }
    
    private static var waitActionDuration: TimeInterval { 1 }
    
    private static var updateProgressActionKey: String { "ProgressIndicator.updateProgressActionKey" }
    
    public var customColor: Color {
        didSet {
            fillColor = customColor.treadmill
        }
    }
    
    public var expectedNumberOfBoxes: Int = 0
    
    public private(set) var receivedBoxesCount: Int = 0
    
    public var showPosition: CGPoint
    
    public var hidePosition: CGPoint
    
    public init(radius: CGFloat, color: Color, showPosition: CGPoint, hidePosition: CGPoint) {
        self.customColor = color
        self.showPosition = showPosition
        self.hidePosition = hidePosition
        
        super.init(radius: radius, color: color.treadmill)
        
        self.radius = radius
        self.position = hidePosition
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func receiveBox() {
        receivedBoxesCount += 1
        let progress = CGFloat(receivedBoxesCount) / CGFloat(expectedNumberOfBoxes)
        setProgress(progress, animated: true)
    }
    
    public func setProgress(_ progress: CGFloat, animated: Bool) {
        guard animated else {
            setProgress(progress)
            return
        }
        
        removeAction(forKey: Self.updateProgressActionKey)
        
        let moveInAction = SKAction.move(to: showPosition, duration: Self.moveActionDuration)
        let firstWaitAction = SKAction.wait(forDuration: Self.waitActionDuration / 2)
        let updateProgressAction = SKAction.run { [weak self] in self?.setProgress(progress) }
        let secondWaitAction = SKAction.wait(forDuration: Self.waitActionDuration)
        let moveOutAction = SKAction.move(to: hidePosition, duration: Self.moveActionDuration)
        
        moveInAction.timingMode = .easeOut
        moveOutAction.timingMode = .easeIn
        
        let action = SKAction.sequence(
            [moveInAction, firstWaitAction, updateProgressAction, secondWaitAction, moveOutAction]
        )
        run(action, withKey: Self.updateProgressActionKey)
    }
    
}
