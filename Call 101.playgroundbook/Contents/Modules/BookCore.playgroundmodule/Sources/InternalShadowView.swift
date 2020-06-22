//
//  InternalShadowView.swift
//  RealityKit101
//
//  Created by Vinícius Bonemer on 15/04/20.
//  Copyright © 2020 Vinícius Bonemer. All rights reserved.
//

import UIKit

/// A view that draws an internal shadow
///
/// This view uses a `InternalShadowLayer` to draw it's shadow
public class InternalShadowView: UIView {
    
    private lazy var shadowLayer: InternalShadowLayer = {
        let shadowLayer = InternalShadowLayer(frame: bounds,
                                              edges: [.top, .bottom],
                                              shadowDepth: 10,
                                              opacity: Float(0.4))
        shadowLayer.shadowColor = UIColor.black.cgColor
        self.layer.addSublayer(shadowLayer)
        return shadowLayer
    }()
    
    /// The shadow depth measured in points
    ///
    /// Defauts to 10
    public var shadowDepth: CGFloat {
        get { shadowLayer.shadowDepth }
        set { shadowLayer.shadowDepth = newValue }
    }
    
    /// The color of the shadow
    ///
    /// Defauts to black
    public var shadowColor: UIColor {
        get {
            guard let cgColor = shadowLayer.shadowColor else { return .black }
            return UIColor(cgColor: cgColor)
        }
        set { shadowLayer.shadowColor = newValue.cgColor }
    }
    
    /// The opacity of the shadow
    ///
    /// Ranges between 0 and 1. Defauts to 0.4
    public var shadowOpacity: CGFloat {
        get { CGFloat(shadowLayer.opacity) }
        set { shadowLayer.opacity = Float(newValue) }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        shadowLayer.frame = bounds
        super.layoutSubviews()
    }
}
