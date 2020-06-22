//
//  TreadmillScene.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public class TreadmillScene: SKScene {
    
    internal static var defaultSize: CGSize { CGSize(width: 512, height: 768) }
    
    static var originalBackgroundColor: UIColor { .clear }
    
    private lazy var qualityAssurer = QualityAssurer()
    
    private lazy var tracker: PackageTracker = PackageTracker()
    
    public weak var endDelegate: TreadmillSceneEndDelegate?
    
    public lazy var topProgressIndicator: TreadmillProgressIndicator = {
        ProgressIndicatorFactory.createProgressIndicator(for: tracker.topRightTreadmill)
    }()
    
    public lazy var middleProgressIndicator: TreadmillProgressIndicator = {
        ProgressIndicatorFactory.createProgressIndicator(for: tracker.middleRightTreadmill)
    }()
    
    public lazy var bottomProgressIndicator: TreadmillProgressIndicator = {
        ProgressIndicatorFactory.createProgressIndicator(for: tracker.bottomRightTreadmill)
    }()
    
    // Methods
    
    internal func addBox(_ box: Box) {
        box.dragDelegate = qualityAssurer
        
        addChild(box)
    }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        backgroundColor = Self.originalBackgroundColor
        
        setUpNodeHierarchy()
//        start()
        
//        respondToSizeChange(oldSize: TreadmillScene.defaultSize)
    }
    
    var totalExpectedBoxes = 0
    var totalReceivedBoxes = 0
    
    public func start() {
        let treadmills = [tracker.topRightTreadmill,
                          tracker.middleRightTreadmill,
                          tracker.bottomRightTreadmill]
        let progressIndicators = [topProgressIndicator,
                                  middleProgressIndicator,
                                  bottomProgressIndicator]
        zip(treadmills, progressIndicators).forEach { (tuple) in
            let (treadmill, indicator) = tuple
            let count = tracker.expectedPackgeCount(for: treadmill)
            indicator.expectedNumberOfBoxes = count
            totalExpectedBoxes += count
        }
        
        qualityAssurer.start(on: self)
        tracker.start(on: self)
    }
    
    func finish() {
        
    }
    
//    private func respondToSizeChange(oldSize: CGSize) {
//        let newSize = size
//        let xRatio = newSize.width / oldSize.width
//        let yRatio = newSize.height / oldSize.height
//    }
    
    private func setUpNodeHierarchy() {
        addChildren(
            tracker.topLeftTreadmill,
            tracker.middleLeftTreadmill,
            tracker.bottomLeftTreadmill,
            tracker.topRightTreadmill,
            tracker.middleRightTreadmill,
            tracker.bottomRightTreadmill
        )
        
        addChildren(
            topProgressIndicator,
            middleProgressIndicator,
            bottomProgressIndicator
        )
    }
    
    internal func removeBox(_ box: Box) {
        box.removeFromParent()
        
        // Check if there are any boxes left
        guard
            tracker.isFinished,
            children.lazy.compactMap({ $0 as? Box }).isEmpty
            else { return }
        
        finish()
    }
    
    internal func didPlaceBox(_ box: Box, on treadmill: Treadmill) {
        var distance = treadmill.size.width + box.size.width / 2
        
        if treadmill.side == .right { distance += box.size.width * 1.5 }
        
        let moveAction = SKAction.moveBy(x: distance, y: 0, duration: 4)
        
        guard treadmill.side == .right else {
            box.run(moveAction)
            return
        }
        
        let removeAction = SKAction.run { [weak self, weak box] in
            guard let box = box else { return }
            self?.removeBox(box)
        }
        let action = SKAction.sequence([moveAction, removeAction])
        box.run(action)
        
        updateProgress(for: treadmill)
    }
    
    private func updateProgress(for treadmill: Treadmill) {
        switch treadmill {
        case tracker.topRightTreadmill:
            topProgressIndicator.receiveBox()
            
        case tracker.middleRightTreadmill:
            middleProgressIndicator.receiveBox()
            
        case tracker.bottomRightTreadmill:
            bottomProgressIndicator.receiveBox()
            
        default:
            fatalError()
        }
    }
    
//    public override func didChangeSize(_ oldSize: CGSize) {
//        super.didChangeSize(oldSize)
//        
//        respondToSizeChange(oldSize: oldSize)
//    }
    
}

internal extension TreadmillScene {
    
    private static var statusIndicationActionKey: String { "statusIndicationActionKey" }
    
    private static var defaultStatusIndicationActionDuration: Double { 0.6 }
    
    private static var quickStatusIndicationActionDuration: Double { 0.3 }
    
    private static var blinkActionDuration: Double { 0.1 }
    
    func indicateNormality() {
        let duration = TreadmillScene.defaultStatusIndicationActionDuration
        let colorize = SKAction.colorize(with: Self.originalBackgroundColor,
                                         colorBlendFactor: 1,
                                         duration: duration)
        scene?.removeAction(forKey: TreadmillScene.statusIndicationActionKey)
        scene?.run(colorize, withKey: TreadmillScene.statusIndicationActionKey)
    }
    
    // Box Color
//    func indicateImminentSuccess(for box: Box) {
//        let duration = TreadmillScene.quickStatusIndicationActionDuration
//        let colorize = SKAction.colorize(with: box.customColor.treadmill,
//                                         colorBlendFactor: 1,
//                                         duration: duration)
//
//        scene?.removeAction(forKey: TreadmillScene.statusIndicationActionKey)
//        scene?.run(colorize, withKey: TreadmillScene.statusIndicationActionKey)
//    }
    
    // Green
    func indicateImminentSuccess(for box: Box) {
        let duration = TreadmillScene.quickStatusIndicationActionDuration
        let colorize = SKAction.colorize(with: Color.green.lightFeedback,
                                         colorBlendFactor: 1,
                                         duration: duration)
        
        scene?.removeAction(forKey: TreadmillScene.statusIndicationActionKey)
        scene?.run(colorize, withKey: TreadmillScene.statusIndicationActionKey)
    }
    
    func indicateImminentFailure() {
        let duration = TreadmillScene.quickStatusIndicationActionDuration
        let colorize = SKAction.colorize(with: Color.red.lightFeedback,
                                         colorBlendFactor: 1,
                                         duration: duration)
        
        scene?.removeAction(forKey: TreadmillScene.statusIndicationActionKey)
        scene?.run(colorize, withKey: TreadmillScene.statusIndicationActionKey)
    }
    
    func indicateFailure() {
        Player.current.playFailureSound()
        let duration = TreadmillScene.quickStatusIndicationActionDuration
        let pump = SKAction.colorize(with: Color.red.strongFeedback,
                                     colorBlendFactor: 0.1,
                                     duration: duration)
        let colorize = SKAction.colorize(with: Color.red.lightFeedback,
                                         colorBlendFactor: 0.1,
                                         duration: duration)
        
        let action = SKAction.sequence([pump, colorize])
        scene?.removeAction(forKey: TreadmillScene.statusIndicationActionKey)
        scene?.run(action, withKey: TreadmillScene.statusIndicationActionKey)
    }
    
    // Box Color
//    func indicateSuccess(for box: Box) {
//        let duration = TreadmillScene.quickStatusIndicationActionDuration
//        let colorize = SKAction.colorize(with: box.customColor.endPoint,
//                                         colorBlendFactor: 0.1,
//                                         duration: duration)
//        let wait = SKAction.wait(forDuration: TreadmillScene.defaultStatusIndicationActionDuration)
//        let normalize = SKAction.run { [weak self] in self?.indicateNormality() }
//
//        let action = SKAction.sequence([colorize, wait, normalize])
//        scene?.removeAction(forKey: TreadmillScene.statusIndicationActionKey)
//        scene?.run(action, withKey: TreadmillScene.statusIndicationActionKey)
//    }
    
    // Green blink
    func indicateSuccess(for box: Box) {
        Player.current.playSuccessSound()
        let duration = TreadmillScene.blinkActionDuration
        let colorize = SKAction.colorize(with: Color.green.strongFeedback,
                                         colorBlendFactor: 0.1,
                                         duration: duration)
        let normalize = SKAction.run { [weak self] in self?.indicateNormality() }
        
        let action = SKAction.sequence([colorize, normalize])
        scene?.removeAction(forKey: TreadmillScene.statusIndicationActionKey)
        scene?.run(action, withKey: TreadmillScene.statusIndicationActionKey)
        
        totalReceivedBoxes += 1
        if totalReceivedBoxes == totalExpectedBoxes {
            endDelegate?.sceneDidEnd(self)
        }
    }
    
}

extension TreadmillScene {
    
    internal enum PhysicsCategory: Int {
        case none = -1
        case treadmill = 0
        case box = 1
        case draggedBox = 2
        
        internal var bitMask: UInt32 { 0b1 << rawValue }
    }
    
}

extension TreadmillScene {
    
    public enum Layer: Int {
        case floor
        case treadmill
        case box
        case lowUI
        case draggedNode
        case highUI
        
        public var zPosition: CGFloat {
            5 * CGFloat(rawValue)
        }
    }
    
}

public protocol TreadmillSceneEndDelegate: class {
    
    func sceneDidEnd(_ scene: TreadmillScene)
}


