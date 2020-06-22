//
//  WaveScene.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 16/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import Combine
import SpriteKit

public class WaveScene: SKScene {
    
    public static var animationHappening = PassthroughSubject<Bool, Never>()
    
    public let byte: [Int] = {
        var a = [Int]()
        a.reserveCapacity(8)
        let oneCount = Int.random(in: 3...5)
        for i in 1...8 {
            if i < oneCount { a.append(1) }
            else { a.append(0) }
        }
        return a.shuffled()
    }()
    
    public lazy var waveNodes: [WaveNode] = {
        var bounds = frame
        if let parent = parent {
            bounds.origin = convert(frame.origin, from: parent)
        }
        
        return byte.map {
            let descriptor = WaveDescriptor(frame: bounds,
                                            representedBit: $0,
                                            relativeAmplitude: 0.8)
            let node = WaveFactory.createWaveNode(from: descriptor)
//            node.animationDelegate = self
            return node
        }
    }()
    
    private var currentBitIndex: Int = 0
    
    fileprivate var didStartAnimation = true
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        backgroundColor = .clear
        
        waveNodes.forEach({ $0.prepareActions() })
        
        setUpNodeHierarchy()
        
//        startWaveAnimation()
    }
    
//    fileprivate func getWave(for bit: Int) -> WaveNode {
//        if bit == 0 {
//            return zeroWave
//        } else {
//            return oneWave
//        }
//    }
    
    var action: SKAction?
    
    public func receive(bit: Int) -> Bool {
        if byte[currentBitIndex - 1] == bit {
            startWaveAnimation()
            return true
        }
        return false
    }
    
    public func startWaveAnimation() {
        let currentWave: WaveNode
        let vector: CGVector
        var shouldPublish = true
        
        if currentBitIndex >= waveNodes.count {
            currentWave = waveNodes.last!
            vector = CGVector(dx: currentWave.frame.width, dy: 0)
            shouldPublish = false
        } else {
            currentWave = waveNodes[currentBitIndex]
            vector = currentWave.getVectorToCenter()
        }
        
//        let distance = vector.dx
        let duration = 2.0//TimeInterval(distance) / TimeInterval(waveNodes.first!.waveSpeed)
        let moveAction: SKAction = .move(by: vector,
                       duration: duration)
        moveAction.timingMode = .easeInEaseOut
        var publishAction: SKAction = .run { WaveScene.animationHappening.send(false) }
        let action: SKAction
        if !shouldPublish {
            publishAction = .run { WaveScene.animationHappening.send(completion: .finished) }
        }
        action = .sequence([moveAction, publishAction])
        
        waveNodes.forEach { $0.run(action, withKey: WaveNode.actionKey) }
        WaveScene.animationHappening.send(true)
        currentBitIndex += 1
    }
    
    private func setUpNodeHierarchy() {
        waveNodes.forEach(addChild(_:))
        
        waveNodes.first!.position.x = -waveNodes.first!.frame.width + 2
        waveNodes.first!.position.y = 0
        for i in 1..<waveNodes.count {
            waveNodes[i].position.x = waveNodes[i-1].position.x - waveNodes[i-1].frame.width + 2
            waveNodes[i].position.y = i.isMultiple(of: 2) ? 0 : 1
        }
    }
    
}

//extension WaveScene: WaveAnimationDelegate {
//
//    public func waveShouldStopAnimating(_ wave: WaveNode) -> Bool {
//        let centeredNode = waveNodes.first {
//            $0.contains($0.convert(frame.center, from: self))
//        }
//        return centeredNode != nil
//    }
//
//}

//extension WaveScene: WaveAnimationDelegate {
//
//    public func waveShouldStopAnimating(_ wave: WaveNode) -> Bool {
//        wave.strokeColor = currentBitIndex.isMultiple(of: 2) ? .red : .black
//        guard !didStartAnimation else {
//            didStartAnimation = false
//            return false
//        }
//
//        guard currentBitIndex < byte.count - 1 else { return true }
//        currentBitIndex += 1
//
//        let currentBit = byte[currentBitIndex]
//        if wave.bit == currentBit {
//            // Restart this wave
//            return false
//        } else {
//            // Start new wave
//            let nextWave = getWave(for: currentBit)
//            nextWave.startAnimating()
//            didStartAnimation = true
//            return true
//        }
//    }
//
//}
