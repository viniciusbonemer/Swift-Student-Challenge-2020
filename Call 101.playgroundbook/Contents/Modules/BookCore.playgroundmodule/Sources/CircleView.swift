//
//  CircleView.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 11/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public class CircleView: UIView {
    
    private static var strokeColor: UIColor {
        TelephoneView.DARK ? UIColor(hex: 0xEEEEEE) : UIColor(hex: 0x111111)
    }
    
    private static var fillColor: UIColor {
        UIColor(hex: 0xD8D8D8)
    }
    
    public var color: UIColor = CircleView.fillColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUp() {
        backgroundColor = .clear
        layer.masksToBounds = true
    }
    
    public override func draw(_ rect: CGRect) {
        let insetRect = rect.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        let path = UIBezierPath(ovalIn: insetRect)
        path.lineWidth = 2
        
        color.setFill()
        CircleView.strokeColor.setStroke()
        
        path.fill()
        path.stroke()
    }
}

