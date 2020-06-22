//
//  InternalEdgeShadowLayer.swift
//  RealityKit101
//
//  Created by Vinícius Bonemer on 15/04/20.
//  Copyright © 2020 Vinícius Bonemer. All rights reserved.
//

import UIKit

/// A layer that draws a shadow in the inside of one edge of a view or another layer
///
/// Instead of using this class directly, prefer `InternalShadowLayer`. This allows you to create shadows
/// on more than one edge.
public final class InternalEdgeShadowLayer: CAGradientLayer {
    
    /// The frame of the layer whose edge casts this shadow
    public var enclosingFrame: CGRect {
        didSet {
            updateFrame()
        }
    }
    
    /// The shadow depth measured in points
    ///
    /// If the shadow is horizontal, this is equivalent to the shadow's height. If, instead, the shadow is vertical,
    /// This corresponds to it's width.
    public var shadowDepth: CGFloat  {
        didSet { updateFrame() }
    }
    
    private var _shadowColor: CGColor?
    
    /// The color of the shadow
    public override var shadowColor: CGColor? {
        get { _shadowColor }
        set {
            _shadowColor = newValue
            updateGradientColor()
        }
    }
    
    /// The edge that casts this shadow.
    ///
    /// This influences the shadow's shape and direction.
    public var edge: UIRectEdge {
        didSet {
            updateFrame()
            updateEndPoints()
        }
    }
    
    /// Creates a new InternalEdgeShadowLayer
    ///
    /// - Parameters:
    ///   - frame: The frame of the layer whose edge casts this shadow
    ///   - edge: The edge that casts this shadow.
    ///   - shadowDepth: The shadow depth measured in points
    public init(frame: CGRect, edge: UIRectEdge, shadowDepth: CGFloat) {
        self.enclosingFrame = frame
        self.edge = edge
        self.shadowDepth = shadowDepth
        
        super.init()
        self.shadowColor = UIColor.black.cgColor
        
        updateFrame()
        updateEndPoints()
        updateGradientColor()
    }
    
    public override init(layer: Any) {
        guard let customLayer = layer as? InternalEdgeShadowLayer else {
            fatalError()
        }
        self.enclosingFrame = customLayer.enclosingFrame
        self.edge = customLayer.edge
        self.shadowDepth = customLayer.shadowDepth
        
        super.init(layer: layer)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates the frame to match changes in the shadow
    ///
    /// This is based on the shadow's `enclosingFrame`, `shadowDepth` and `edge`.
    private func updateFrame() {
        let size: CGSize
        if [.top, .bottom].contains(edge) {
            size = CGSize(width: enclosingFrame.width, height: shadowDepth)
        } else {
            size = CGSize(width: shadowDepth, height: enclosingFrame.height)
        }
        
        switch edge {
        case .top:
            frame = CGRect(origin: .zero,
                           size: size)
        case .bottom:
            frame = CGRect(origin: CGPoint(x: 0, y: enclosingFrame.height - shadowDepth),
                           size: size)
        case .left:
            frame = CGRect(origin: .zero,
                           size: size)
        case .right:
            frame = CGRect(origin: CGPoint(x: enclosingFrame.width - shadowDepth, y: 0),
                           size: size)
        default:
            break
        }
    }
    
    /// Updates the gradient's end points to match changes in the shadow
    ///
    /// This is based on the shadow's `edge`.
    private func updateEndPoints() {
        switch edge {
        case .top:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint   = CGPoint(x: 0.5, y: 1.0)
        case .bottom:
            startPoint = CGPoint(x: 0.5, y: 1.0)
            endPoint   = CGPoint(x: 0.5, y: 0.0)
        case .left:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint   = CGPoint(x: 1.0, y: 0.5)
        case .right:
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint   = CGPoint(x: 0.0, y: 0.5)
        default:
            break
        }
    }
    
    /// Updates the gradient's colors to match changes in the shadow
    ///
    /// This is based on the shadow's `shadowColor`.
    private func updateGradientColor() {
        guard let shadowColor = shadowColor else { return }
        
        let endColor = UIColor(cgColor: shadowColor)
            .withAlphaComponent(0)
            .cgColor
        colors = [shadowColor, endColor]
    }
}
