//
//  BoxFactory.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

enum BoxFactory {
    
    static private var boxSize: CGSize { CGSize(width: 64, height: 55) }
    
    static private var physicsBodySize: CGSize {
//        CGSize(width: boxSize.width - 30,
//               height: boxSize.height - 20)
        boxSize
    }
    
    static func generatePhysicsBody(for box: Box) {
        let physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize, center: .zero)
        
        physicsBody.categoryBitMask = TreadmillScene.PhysicsCategory.box.bitMask
        physicsBody.collisionBitMask = TreadmillScene.PhysicsCategory.box.bitMask
        
        physicsBody.affectedByGravity = false
        
        box.physicsBody = physicsBody
    }
    
    static func createBox(color: Color) -> Box {
        let image = Assets.box(color: color)
        let texture = SKTexture(image: image)
        
        let box = Box(texture: texture, customColor: color, size: boxSize)
        box.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        box.zPosition = TreadmillScene.Layer.box.zPosition
        
        generatePhysicsBody(for: box)
        
        return box
    }
    
}
