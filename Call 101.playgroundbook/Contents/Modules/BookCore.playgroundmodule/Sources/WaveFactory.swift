//
//  WaveFactory.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 16/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit
import SpriteKit

public enum WaveFactory {
    
    static func createWavePath(from descriptor: WaveDescriptor) -> CGPath {
        let frequency: CGFloat
        if descriptor.relativeFrequency == nil {
            frequency = descriptor.representedBit == 0 ? 2 : 8
        } else {
            frequency = descriptor.relativeFrequency!
        }
        let amplitude = descriptor.relativeAmplitude * (descriptor.frame.height / 2)

        let initialX: CGFloat = descriptor.frame.minX + descriptor.xDisloc
        let finalX: CGFloat = descriptor.frame.maxX + descriptor.xDisloc

        let path = CGMutablePath()
        var first = true

        for x in stride(from: initialX, through: finalX, by: 1) {
            var angle = x.mapped(from: initialX...finalX,
                                 to: 0...(2 * .pi))
            angle = frequency * angle
            let y = amplitude * (sin(angle) + descriptor.yDisloc)
            let point = CGPoint(x: x, y: y)
            
            guard first else {
                path.addLine(to: point)
                continue
            }
            
            path.move(to: point)
            first = false
        }
        
        return path
        
//        let shape = SKShapeNode(path: path)
//        shape.lineWidth = 2
//        shape.strokeColor = .systemPink
//        shape.position = CGPoint(x: initialX, y: 0)
//
//        let cropNode = SKCropNode()
//        let mask = SKShapeNode(rectOf: CGSize(width: 200, height: 2*amplitude))
//        mask.fillColor = .black
//        cropNode.maskNode = mask
//        cropNode.addChild(shape)
//        self.addChild(cropNode)
//
//        let moveRightAction = SKAction.sequence([
//            SKAction.move(to: CGPoint(x: finalX, y: 0), duration: 10),
//            SKAction.move(to: CGPoint(x: initialX, y: 0), duration: 0)
//        ])
//
//        shape.run(SKAction.repeatForever(moveRightAction))
    }
    
    public static func createWaveNode(from descriptor: WaveDescriptor) -> WaveNode {
        let path = createWavePath(from: descriptor)
        let node = WaveNode()
        node.path = path
        node.bit = descriptor.representedBit
        
        return node
    }
    
}
