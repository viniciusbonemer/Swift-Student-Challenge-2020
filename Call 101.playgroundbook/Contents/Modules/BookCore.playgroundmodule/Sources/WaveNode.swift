//
//  WaveNode.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 16/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public class WaveNode: SKShapeNode {
    
    static var actionKey: String { "WaveNode.moveRightAction" }
    
//    public var waveSpeed: CGFloat = 2 * 64
    
    @Clamping(min: 0, max: 1)
    public var bit: Int = 0
    
    public weak var animationDelegate: WaveAnimationDelegate?
    
    public override init() {
        super.init()
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private func setUp() {
        lineWidth = 4
        strokeColor = UIColor(hex: 0x111111).withAlphaComponent(0.8)
        fillColor = .clear
    }
    
    private var isFirstAction = true
    public var isReady = false
    
    public var firstAction: SKAction?
    public var cycleAction: SKAction?
    public var endAction: SKAction?
    
    public func prepareActions() {
        guard !isReady else { return }
        
        let cycleStartX = -frame.width / 2
        let cycleEndX: CGFloat = 0
        
        let cycleStartPosition = CGPoint(x: cycleStartX, y: 0)
        let cycleEndPosition = CGPoint(x: cycleEndX, y: 0)
        
        let duration = 2.0//TimeInterval(cycleEndX - cycleStartX) / TimeInterval(waveSpeed)
        
        let moveForwards: SKAction = .move(to: cycleEndPosition, duration: duration)
        let jumpBack: SKAction = .run { [weak self] in self?.position = cycleStartPosition }
        let restart: SKAction = .run { [weak self] in self?.startAnimating() }
        
        cycleAction = .sequence([moveForwards, jumpBack, restart])
        
        let finalX = frame.width / 2
        let finalPosition = CGPoint(x: finalX, y: 0)
        let moveOutAction: SKAction = .move(to: finalPosition, duration: duration)
        let resetAction: SKAction = .run { [weak self] in self?.reset() }
        endAction = .sequence([moveOutAction, resetAction])
        
        let firstX = -frame.width
        let firstPosition = CGPoint(x: firstX, y: 0)
        
        position = firstPosition
        
        let appear: SKAction = .move(to: cycleStartPosition, duration: duration)
        firstAction = .sequence([appear, cycleAction!])
        
        isReady = true
    }
    
    public func getVectorToCenter() -> CGVector {
        CGVector(dx: -position.x, dy: 0)
    }
    
    public func startAnimating() {
        
        if !isReady {
            prepareActions()
        }
        
        removeAction(forKey: Self.actionKey)
        
        let shouldStopAnimating = animationDelegate?.waveShouldStopAnimating(self) ?? true
        
        guard !shouldStopAnimating else {
            run(endAction!, withKey: Self.actionKey)
            return
        }
        
        guard isFirstAction else {
            run(cycleAction!, withKey: Self.actionKey)
            return
        }
        
        isFirstAction = false
        
        run(firstAction!, withKey: Self.actionKey)
    }
    
    public func reset() {
        position = CGPoint(x: -frame.width, y: 0)
        isFirstAction = true
    }
    
    public func stopAnimating() {
        removeAction(forKey: Self.actionKey)
    }
    
}

public protocol WaveAnimationDelegate: class {
    
    func waveShouldStopAnimating(_ wave: WaveNode) -> Bool
    
}
