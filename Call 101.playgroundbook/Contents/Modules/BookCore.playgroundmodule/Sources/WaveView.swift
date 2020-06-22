//
//  WaveView.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 15/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public class WaveView: UIView {
    
    public var shapeLayer: CAShapeLayer { layer as! CAShapeLayer }
    
    public override class var layerClass: AnyClass { CAShapeLayer.self }
    
    public var representedBit: Int = 0
    
    private lazy var waveDescriptor = WaveDescriptor(frame: .zero,
                                                representedBit: representedBit,
                                                yDisloc: 1.2,
                                                relativeFrequency: CGFloat(representedBit + 1),
                                                relativeAmplitude: 0.8)
    
    public var lineColor: UIColor {
        get {
            guard let color = shapeLayer.strokeColor else {
                return UIColor.black
            }
            return UIColor(cgColor: color)
        }
        set {
            shapeLayer.borderColor = newValue.cgColor
            shapeLayer.strokeColor = newValue.cgColor
        }
    }
    
    // MARK: Initialization
    
    public init(bit: Int) {
        super.init(frame: .zero)
        
        self.representedBit = bit
        
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
    }
    
    // MARK: Methods
    
    private func setUp() {
        contentMode = .scaleAspectFit
        backgroundColor = UIColor.white.withAlphaComponent(0.6)
        isUserInteractionEnabled = false
        
        shapeLayer.masksToBounds = true
        shapeLayer.cornerRadius = 12
        shapeLayer.borderWidth = 1
        shapeLayer.lineWidth = 4
        shapeLayer.fillColor = UIColor.clear.cgColor
    }
    
    public override func didMoveToWindow() {
        waveDescriptor.frame = bounds
    }
    
    public override func layoutSubviews() {
        var shouldUpdatePath = false
        if frame != waveDescriptor.frame {
            waveDescriptor.frame = frame
            shouldUpdatePath = true
        }
        if representedBit != waveDescriptor.representedBit {
            waveDescriptor.representedBit = representedBit
            shouldUpdatePath = true
        }
        if shouldUpdatePath {
            shapeLayer.path = WaveFactory.createWavePath(from: waveDescriptor)
        }
        
        super.layoutSubviews()
    }
    
}

//public class WaveView: UIView {
//
//    // MARK: Properties
//
//    public override class var layerClass: AnyClass { CAShapeLayer.self }
//
//    private var shapeLayer: CAShapeLayer { layer as! CAShapeLayer }
//
//    private static var animationKey: String { "WaveView.pathAnimation" }
//
//    private var animationDuration: TimeInterval { highFrequency ? 0.25 : 0.5 }
//
//    private static var pathKeyPath: String { "path" }
//
//    fileprivate var shouldInvertAnimation = false
//
//    fileprivate var originalPath: CGPath?
//
//    fileprivate var originalAnimation: CAAnimation?
//
//    fileprivate var invertedPath: CGPath?
//
//    fileprivate var invertedAnimation: CAAnimation?
//
//    public var waveColor: UIColor {
//        get {
//            guard let color = shapeLayer.strokeColor else {
//                let defaultColor = UIColor.black
//                shapeLayer.strokeColor = defaultColor.cgColor
//                return defaultColor
//            }
//            return UIColor(cgColor: color)
//        }
//        set {
//            shapeLayer.strokeColor = newValue.cgColor
//        }
//    }
//
//    public var waveWidth: CGFloat {
//        get { shapeLayer.lineWidth }
//        set { shapeLayer.lineWidth = newValue }
//    }
//
//    public var highFrequency: Bool = false {
//        willSet {
//            guard newValue != highFrequency else { return }
//            originalPath = nil
//            invertedPath = nil
//            originalAnimation = nil
//            invertedAnimation = nil
//        }
//    }
//
//    private var lastFrame: CGRect = .zero
//
//    // MARK: Initialization
//
//    public convenience init() {
//        self.init(frame: .zero)
//    }
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setUp()
//    }
//
//    public required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        setUp()
//    }
//
//    // MARK: Methods
//
//    private func setUp() {
//        shapeLayer.fillColor = nil
//    }
//
//    public override func didMoveToWindow() {
//        print(frame)
//        originalPath = createWavePath(inverted: false)
//        invertedPath = createWavePath(inverted: true)
//        shapeLayer.path = originalPath
//        activateDebugFrame()
//        startAnimation()
//    }
//
//    public override func layoutSubviews() {
//        if frame != lastFrame {
//            lastFrame = frame
//            originalPath = nil
//            invertedPath = nil
//            originalAnimation = nil
//            invertedAnimation = nil
//        }
//
//        super.layoutSubviews()
//    }
//
//    func getExistingWavePath(inverted: Bool) -> CGPath? {
//        if inverted { return invertedPath }
//        return originalPath
//    }
//
//    private func createWavePath(inverted: Bool = false) -> CGPath {
//
//        if let path = getExistingWavePath(inverted: inverted) {
//            return path
//        }
//
//        let multiplier: CGFloat = inverted ? 1.0 : -1.0
//        let width = frame.width
//        let height = frame.height * multiplier
//        let origin = CGPoint(x: 0, y: frame.height / 2)
//
//        let path = CGMutablePath()
//        path.move(to: origin)
//
//        let start: CGFloat = 5
//        let end: CGFloat = 360 * (highFrequency ? 4 : 1)
//        let step: CGFloat = 5
//
//        for angle in stride(from: start, through: end, by: step) {
//            let radians = angle.degreesToRadians
//            let deltaX = (angle / end) * width
//            let x = origin.x + deltaX
//            let y = origin.y - sin(radians) * height / 2
//            path.addLine(to: CGPoint(x: x, y: y))
//        }
//
//        if inverted { self.invertedPath = path }
//        else { self.originalPath = path }
//
//        return path
//    }
//
//    fileprivate func getExistingAnimation(inverted: Bool) -> CAAnimation? {
//        if inverted { return invertedAnimation }
//        return originalAnimation
//    }
//
//    fileprivate func createAnimation(inverted: Bool = false) -> CAAnimation {
//
//        if let animation = getExistingAnimation(inverted: inverted) {
//            return animation
//        }
//
//        let startPath = createWavePath(inverted: inverted)
//        let finalPath = createWavePath(inverted: !inverted)
//
//        let animation = CABasicAnimation(keyPath: Self.pathKeyPath)
//        animation.duration = animationDuration
//        animation.fromValue = startPath
//        animation.toValue = finalPath
//        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//
//        animation.delegate = self
//
//        if inverted { invertedAnimation = animation }
//        else { originalAnimation = animation }
//
//        return animation
//    }
//
//    private func startAnimation() {
//        stopAnimation()
//
//        let animation = createAnimation(inverted: shouldInvertAnimation)
//        shapeLayer.add(animation, forKey: Self.animationKey)
//    }
//
//    private func stopAnimation() {
//        shapeLayer.removeAnimation(forKey: Self.animationKey)
//    }
//
//}
//
//extension WaveView: CAAnimationDelegate {
//
//    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        guard flag else { return }
//
//        startAnimation()
//        shouldInvertAnimation.toggle()
//    }
//
//}
//
//extension CGFloat {
//
//    fileprivate var degreesToRadians: CGFloat {
//        self / 180.0 * .pi
//    }
//
//}
