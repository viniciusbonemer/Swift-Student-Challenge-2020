//
//  InternalShadowLayer.swift
//  RealityKit101
//
//  Created by Vinícius Bonemer on 15/04/20.
//  Copyright © 2020 Vinícius Bonemer. All rights reserved.
//

import UIKit

/// A layer that draws a shadow in the inside of a view or another layer
///
/// This class allows you to specify shadows on all edges of the view, or specific edges, instead
public final class InternalShadowLayer: CALayer {
    
    /// Recognized edges
    private static var edges: [UIRectEdge] {
        [.bottom, .left, .right, .top]
    }
    
    /// The shadow depth measured in points
    public var shadowDepth: CGFloat = 0 {
        didSet {
            sublayers?.lazy
                .compactMap({ $0 as? InternalEdgeShadowLayer })
                .forEach({ $0.shadowDepth = self.shadowDepth })
        }
    }
    
    private var _shadowColor: CGColor?
    
    /// The color of the shadow
    public override var shadowColor: CGColor? {
        get {
            _shadowColor
        }
        set {
            _shadowColor = newValue
            updateShadowColor()
        }
    }
    
    /// Creates a new InternalShadowLayer
    ///
    /// - Parameters:
    ///   - frame: The frame of the layer that casts this shadow
    ///   - edges: The edges whose shadows are being cast
    ///   - shadowDepth: The depth of the shadows measured in points
    ///   - shadowColor: The color of the shadows
    ///   - opacity: The opacity of the cast shadow on the closest point to the edge
    public init(frame: CGRect = .zero, edges: UIRectEdge = .all, shadowDepth: CGFloat = 10,
         shadowColor: CGColor = UIColor.black.cgColor,
         opacity: Float = 0.8) {
        self.shadowDepth = shadowDepth
        
        super.init()
        
        self.shadowColor = shadowColor
        self.frame = frame
        self.opacity = opacity
        
        for edge in Self.edges {
            guard edges.contains(edge) else { continue }
            
            let edgeLayer = InternalEdgeShadowLayer(frame: frame,
                                                    edge: edge,
                                                    shadowDepth: shadowDepth)
            edgeLayer.shadowColor = shadowColor
            addSublayer(edgeLayer)
        }
    }
    
    override init(layer: Any) {
        guard let _ = layer as? InternalShadowLayer else {
            fatalError()
        }
        
        super.init(layer: layer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSublayers() {
        updateShadowColor()
        updateShadowFrame()
        
        super.layoutSublayers()
    }
    
    /// Updates the sublayer's shadow colors
    ///
    /// This is based on the shadow's `shadowColor`.
    private func updateShadowColor() {
        guard let sublayers = sublayers else { return }
        
        for case let layer as InternalEdgeShadowLayer in sublayers {
            layer.shadowColor = shadowColor
            layer.opacity = opacity
        }
    }
    
    /// Updates the sublayer's shadow enclosingFrame
    ///
    /// This is based on the shadow's `frame`.
    private func updateShadowFrame() {
        guard let sublayers = sublayers else { return }
        
        for case let layer as InternalEdgeShadowLayer in sublayers {
            layer.enclosingFrame = frame
        }
    }
}
