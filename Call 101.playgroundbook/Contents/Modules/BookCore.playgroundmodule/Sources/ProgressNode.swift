//
//  ProgressNode.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 14/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public class ProgressNode: SKShapeNode {
    
    public var radius: CGFloat
    
    public init(radius: CGFloat, color: UIColor) {
        self.radius = radius
        
        super.init()
        
        fillColor = color
        strokeColor = .black
        lineWidth = 2
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setProgress(_ progress: CGFloat) {
        let consideredProgress = progress.clamped(to: 0...1)
        
        guard progress != 0 else {
            path = nil
            return
        }
        
        guard consideredProgress != 1 else {
            path = UIBezierPath(arcCenter: .zero, radius: radius,
                                startAngle: 0, endAngle: 2 * .pi,
                                clockwise: true).cgPath
            return
        }
        
        let angle = consideredProgress * (2 * .pi)
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: -radius))
        path.addArc(withCenter: .zero, radius: radius,
                    startAngle: -.pi/2, endAngle: -.pi/2 - angle,
                    clockwise: false)
        path.close()
        self.path = path.cgPath
    }
    
}

