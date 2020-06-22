//
//  Box.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public class Box: DraggableNode {
    
    private static var scaleUpActionKey: String {
        "\(String(describing: Self.self)).scaleUpActionKey"
    }
    
    private static var scaleDownActionKey: String {
        "\(String(describing: Self.self)).scaleDownActionKey"
    }
    
    private static var scaleUpFactor: CGFloat { 1.5 }
    
    private static var scaleActionDuration: Double { 0.3 }
    
    public var customColor: Color
    
    public init(texture: SKTexture?, customColor: Color, size: CGSize) {
        self.customColor = customColor
        
        super.init(texture: texture, color: customColor.treadmill, size: size)
    }
    
    public convenience init() {
        self.init(texture: nil, customColor: .gray, size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func dragBegan() {
        super.dragBegan()
        
        physicsBody?.categoryBitMask = TreadmillScene.PhysicsCategory.draggedBox.bitMask
        physicsBody?.collisionBitMask = TreadmillScene.PhysicsCategory.none.bitMask
        removeAction(forKey: Self.scaleDownActionKey)
//        let scaleUp = SKAction.scale(to: Self.scaleUpFactor, duration: Self.scaleActionDuration)
        let scaleUp = SKAction.resize(toWidth: size.width * Self.scaleUpFactor,
                                      height: size.height * Self.scaleUpFactor,
                                      duration: Self.scaleActionDuration)
        run(scaleUp, withKey: Self.scaleUpActionKey)
    }
    
    public override func dragEnded() {
        super.dragEnded()
        
        physicsBody?.categoryBitMask = TreadmillScene.PhysicsCategory.box.bitMask
        physicsBody?.collisionBitMask = TreadmillScene.PhysicsCategory.box.bitMask
        removeAction(forKey: Self.scaleUpActionKey)
//        let scaleDown = SKAction.scale(to: 1, duration: Self.scaleActionDuration)
        let scaleDown = SKAction.resize(toWidth: size.width / Self.scaleUpFactor,
                                      height: size.height / Self.scaleUpFactor,
                                      duration: Self.scaleActionDuration)
        run(scaleDown, withKey: Self.scaleDownActionKey)
    }
    
}
