//
//  TreadmillFactory.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

extension Assets.Treadmill.Size {
    
    fileprivate var nodeSize: CGSize {
        switch self {
        case .short:
            return CGSize(width: 128, height: 100)
        case .long:
            return CGSize(width: 173, height: 100)
        }
    }
    
}

enum TreadmillFactory {
    
    private static func createTreadmillNode(size: Assets.Treadmill.Size,
                                            side: Treadmill.Side,
                                            color: Color) -> Treadmill {
        let image = Assets.treadmill(size: size, color: color)
        let texture = SKTexture(image: image)
        
        let treadmill = Treadmill(texture: texture, customColor: color,
                                  side: side, size: size.nodeSize)
        treadmill.customColor = color
        treadmill.anchorPoint = CGPoint(x: 0, y: 0.5)
        treadmill.zPosition = TreadmillScene.Layer.treadmill.zPosition
        
        return treadmill
    }
    
    private static func createLeftTreadmillNode(size: Assets.Treadmill.Size, color: Color) -> Treadmill {
        return Self.createTreadmillNode(size: size, side: .left, color: .gray)
    }
    
    private static func createRightTreadmillNode(size: Assets.Treadmill.Size, color: Color) -> Treadmill {
        let node = Self.createTreadmillNode(size: size, side: .right, color: color)
        
        node.zRotation = .pi
        generateRightPhysicsBody(for: node)
        
        return node
    }
    
    static func generateRightPhysicsBody(for treadmill: Treadmill) {
//        let frame = treadmill.frame.inset(by: UIEdgeInsets(top: 36, left: 30, bottom: 36, right: 0))
//        let frame = treadmill.frame.inset(by: UIEdgeInsets(top: 46, left: 44, bottom: 46, right: 0))
        let frame = treadmill.frame.inset(by: UIEdgeInsets(top: 38, left: 44, bottom: 38, right: 0))
        let physicsBody = SKPhysicsBody(rectangleOf: frame.size,
                                        center: CGPoint(x: frame.size.width/2, y: 0))
        
        physicsBody.categoryBitMask = TreadmillScene.PhysicsCategory.treadmill.bitMask
        physicsBody.collisionBitMask = TreadmillScene.PhysicsCategory.none.bitMask
        let boxCategory = TreadmillScene.PhysicsCategory.draggedBox
        let draggedBoxCategory = TreadmillScene.PhysicsCategory.box
        let anyBoxBitMask = boxCategory.bitMask | draggedBoxCategory.bitMask
        physicsBody.contactTestBitMask = anyBoxBitMask
        physicsBody.affectedByGravity = false
        
        treadmill.physicsBody = physicsBody
    }
    
    static func createTopLeftTreadmillNode() -> Treadmill {
        let node = createLeftTreadmillNode(size: .long, color: .gray)
        
        node.position = CGPoint(x: -TreadmillScene.defaultSize.width/2, y: 170)
        
        return node
    }
    
    static func createMiddleLeftTreadmillNode() -> Treadmill {
        let node = Self.createLeftTreadmillNode(size: .short, color: .gray)
        
        node.position = CGPoint(x: -TreadmillScene.defaultSize.width/2, y: 0)
        
        return node
    }
    
    static func createBottomLeftTreadmillNode() -> Treadmill {
        let node = Self.createLeftTreadmillNode(size: .long, color: .gray)
        
        node.position = CGPoint(x: -TreadmillScene.defaultSize.width/2, y: -170)
        
        return node
    }
    
    static func createTopRightTreadmillNode(color: Color) -> Treadmill {
        let node = Self.createRightTreadmillNode(size: .long, color: color)
        
        node.position = CGPoint(x: TreadmillScene.defaultSize.width/2, y: 210)
        
        return node
    }
    
    static func createMiddleRightTreadmillNode(color: Color) -> Treadmill {
        let node = Self.createRightTreadmillNode(size: .short, color: color)
        
        node.position = CGPoint(x: TreadmillScene.defaultSize.width/2, y: 0)
        
        return node
    }
    
    static func createBottomRightTreadmillNode(color: Color) -> Treadmill {
        let node = Self.createRightTreadmillNode(size: .long, color: color)
        
        node.position = CGPoint(x: TreadmillScene.defaultSize.width/2, y: -210)
        
        return node
    }
    
}
