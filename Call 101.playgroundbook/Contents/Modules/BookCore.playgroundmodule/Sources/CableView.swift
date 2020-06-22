//
//  CableView.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 11/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public class CableView: UIView {
    
    private static var strokeColor: UIColor {
        TelephoneView.DARK ? UIColor(hex: 0xEEEEEE) : UIColor(hex: 0x111111)
    }
    
    public var color: UIColor {
        set { shapeLayer.strokeColor = newValue.cgColor }
        get { UIColor(cgColor: shapeLayer.strokeColor!) }
    }
    
    
    public weak var leadingAnchorPoint: UIView?
    
    public weak var trailingAnchorPoint: UIView?
    
    public var curveType: CurveType = CurveType.allCases.randomElement()!
    
    public var shapeLayer: CAShapeLayer { layer as! CAShapeLayer }
    
    public override class var layerClass: AnyClass { CAShapeLayer.self }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public convenience init(curveType: CurveType) {
        self.init(frame: .zero)
        
        self.curveType = curveType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = CableView.strokeColor.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
    }
    
    public override func layoutSubviews() {
        guard case nil = shapeLayer.animation(forKey: CableView.vibrationAnimationKey) else {
            super.layoutSubviews()
            return
        }
        
        let path = createPath(for: curveType)
        shapeLayer.path = path

        super.layoutSubviews()
    }
    
}

public extension CableView {
    enum CurveType: CaseIterable {
        case up
        case down
        case downUp
        case upDown
        case straight
        
        public var oposite: CurveType {
            switch self {
            case .up:
                return .down
            case .down:
                return .up
            case .downUp:
                return .upDown
            case .upDown:
                return .downUp
            case .straight:
                return .straight
            }
        }
    }
}

extension CableView {
    
    private static var vibrationAnimationKeyPath = "path"
    
    fileprivate static var vibrationAnimationKey = "CableView.vibrate"
    
    public func vibrate(duration: Double = 1.4) {
        let animation = CAKeyframeAnimation(keyPath: CableView.vibrationAnimationKeyPath)
        
        let currentPath = createPath(for: curveType)
        let opositePath = createPath(for: curveType.oposite)
        
        shapeLayer.path = currentPath
        
        animation.values = [
            currentPath,
            opositePath,
            currentPath,
            opositePath,
            currentPath,
            opositePath,
            currentPath,
            opositePath,
            currentPath
        ]
        animation.keyTimes = [0, 0.2, 0.3, 0.375, 0.5, 0.625, 0.7, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        
        shapeLayer.add(animation, forKey: CableView.vibrationAnimationKey)
    }
    
    public func stopVibrating() {
        let animation = CABasicAnimation(keyPath: CableView.vibrationAnimationKeyPath)
        
        animation.toValue = createPath(for: curveType)
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        shapeLayer.removeAnimation(forKey: CableView.vibrationAnimationKey)
        shapeLayer.add(animation, forKey: CableView.vibrationAnimationKey)
        
        self.shapeLayer.path = createPath(for: curveType)
    }
    
}

fileprivate extension CableView {
    
    func createPath(for curveType: CurveType) -> CGPath {
        let path = UIBezierPath()
        
        var firstPoint = CGPoint(x: bounds.minX, y: bounds.midY)
        
        if let firstAnchorPoint = leadingAnchorPoint {
            firstPoint = convert(firstAnchorPoint.center, from: firstAnchorPoint.superview)
        }
        
        path.move(to: firstPoint)
        
        let (cp1, cp2) = getControlPoints(for: curveType)
        
        var lastPoint = CGPoint(x: bounds.maxX, y: bounds.midY)
        
        if let lastAnchorPoint = trailingAnchorPoint {
            lastPoint = convert(lastAnchorPoint.center, from: lastAnchorPoint.superview)
        }
        
        path.addCurve(to: lastPoint,
                      controlPoint1: cp1,
                      controlPoint2: cp2)
        
        return path.cgPath
    }
    
    func getControlPoints(for curveType: CurveType) -> (cp1: CGPoint, cp2: CGPoint) {
        var up = CGPoint(x: bounds.midX, y: bounds.minY)
        var down = CGPoint(x: bounds.midX, y: bounds.maxY)
        
        if
            let leadingAnchorPoint = leadingAnchorPoint,
            let trailingAnchorPoint = trailingAnchorPoint {
            let firstAP = convert(leadingAnchorPoint.center, from: leadingAnchorPoint.superview)
            let secondAP = convert(trailingAnchorPoint.center, from: trailingAnchorPoint.superview)
            up.x = (firstAP.x + secondAP.x) / 2
            down.x = (firstAP.x + secondAP.x) / 2
        }
        
        switch curveType {
        case .up:
            return (up, up)
        case .down:
            return (down, down)
        case .downUp:
            return (down, up)
        case .upDown:
            return (up, down)
        case .straight:
            let x = (up.x + down.x) / 2
            let y = (up.y + down.y) / 2
            let point = CGPoint(x: x, y: y)
            return (point, point)
        }
    }
    
}
