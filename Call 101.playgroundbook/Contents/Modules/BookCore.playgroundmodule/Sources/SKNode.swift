//
//  SKNode.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    public func addChildren(_ nodes: SKNode...) {
        nodes.forEach { addChild($0) }
    }
    
}
