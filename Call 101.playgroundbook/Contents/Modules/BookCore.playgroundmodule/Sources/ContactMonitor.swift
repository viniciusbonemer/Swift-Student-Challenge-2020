//
//  ContactMonitor.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit
import SpriteKit

public class ContactMonitor<Scene: SKScene>: NSObject, SKPhysicsContactDelegate {
    
    public weak var scene: Scene?
    
    public func startMonitoringScene(_ scene: Scene) {
        self.scene = scene
        scene.physicsWorld.contactDelegate = self
    }
    
    public func didBegin(_ contact: SKPhysicsContact) { }
    
    public func didEnd(_ contact: SKPhysicsContact) { }
    
    internal func decompose<Node1: SKNode, Node2: SKNode>(contact: SKPhysicsContact, body1: inout Node1, body2: inout Node2) throws {
        if let node1 = contact.bodyA.node as? Node1, let node2 = contact.bodyB.node as? Node2 {
            body1 = node1
            body2 = node2
            return
        } else if let node1 = contact.bodyB.node as? Node1, let node2 = contact.bodyA.node as? Node2 {
            body1 = node1
            body2 = node2
            return
        }
        throw DecompositionError(contact: contact, body1: body1, body2: body2)
    }
    
    internal  struct DecompositionError<Node1: SKNode, Node2: SKNode>: Error {
        weak var contact: SKPhysicsContact?
        weak var body1: Node1?
        weak var body2: Node2?
    }
    
}
