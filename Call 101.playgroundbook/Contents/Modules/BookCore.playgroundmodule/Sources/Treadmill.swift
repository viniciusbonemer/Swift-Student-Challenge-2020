//
//  Treadmill.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public final class Treadmill: SKSpriteNode {
    
    public var customColor: Color
    
    public var side: Side
    
    public init(texture: SKTexture?, customColor: Color, side: Side, size: CGSize) {
        self.customColor = customColor
        self.side = side
        
        super.init(texture: texture, color: customColor.treadmill, size: size)
    }
    
    public convenience init() {
        self.init(texture: nil, customColor: .gray, side: .left, size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Treadmill {
    public enum Side {
        case left
        case right
    }
}
