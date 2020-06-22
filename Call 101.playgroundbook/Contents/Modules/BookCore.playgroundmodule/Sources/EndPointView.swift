//
//  EndPointView.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 11/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public class EndPointView: UIView {
    
    public var color: UIColor {
        set {
            circleView.color = newValue
            highlighter.color = newValue
        }
        get {
            circleView.color
        }
    }
    
    public var highlightColor: UIColor {
        set {
            highlighter.color = newValue
        }
        get {
            highlighter.color
        }
    }
    
    public var isHighlighted: Bool = false
    
    private var highlighter: Highlighter = {
        let highlighter = Highlighter()
        
        highlighter.alpha = 0
        highlighter.translatesAutoresizingMaskIntoConstraints = false
        
        return highlighter
    }()
    
    private var circleView: CircleView = {
        let circle = CircleView()
        
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        return circle
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func showHighlight(animated: Bool = true,
                              completion: ((Bool) -> Void)? = nil) {
        isHighlighted = true
        
        guard animated else {
            highlighter.alpha = CGFloat(Highlighter.alpha)
            return
        }
        
        UIView.animate(withDuration: Highlighter.fadeDuration, delay: 0,
                       options: .curveEaseInOut, animations: { [weak self] in
                        self?.highlighter.alpha = CGFloat(Highlighter.alpha)
        }, completion: completion)
    }
    
    public func removeHighlight(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        isHighlighted = false
        
        guard animated else {
            highlighter.alpha = 0
            return
        }
        
        UIView.animate(withDuration: Highlighter.fadeDuration, delay: 0,
                       options: .curveEaseInOut, animations: { [weak self] in
                        self?.highlighter.alpha = 0
        }, completion: completion)
    }
    
    private func setUp() {
        addSubview(highlighter)
        addSubview(circleView)
    }
    
    public override func didMoveToWindow() {
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            highlighter.widthAnchor.constraint(equalToConstant: Highlighter.defaultSize.width),
            highlighter.heightAnchor.constraint(equalToConstant: Highlighter.defaultSize.height)
        ])
        
        NSLayoutConstraint.activate([
            highlighter.topAnchor.constraint(equalTo: topAnchor),
            highlighter.leadingAnchor.constraint(equalTo: leadingAnchor),
            highlighter.bottomAnchor.constraint(equalTo: bottomAnchor),
            highlighter.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            circleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
}

public extension EndPointView {
    
    class Highlighter: UIView {
        
        private static var insets: UIEdgeInsets {
            UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        
        internal static var defaultSize: CGSize {
            CGSize(width: 58, height: 58)
        }
        
        fileprivate static var alpha: Float { 0.4 }
        
        fileprivate static var fadeDuration: Double { 1 }
        
        public var color: UIColor = UIColor.black {
            didSet {
                updateColor()
            }
        }
        
        private lazy var innermostCircle: CALayer = {
            let layer = CALayer()
            
            layer.backgroundColor = color.cgColor
            layer.opacity = Highlighter.alpha
            layer.isOpaque = false
            layer.masksToBounds = true
            
            return layer
        }()
        
        private lazy var middleCircle: CALayer = {
            let layer = CALayer()
            
            layer.backgroundColor = color.cgColor
            layer.opacity = Highlighter.alpha
            layer.isOpaque = false
            layer.masksToBounds = true
            
            return layer
        }()
        
        private lazy var outermostCircle: CALayer = {
            let layer = CALayer()
            
            layer.backgroundColor = color.cgColor
            layer.opacity = Highlighter.alpha
            layer.isOpaque = false
            layer.masksToBounds = true
            
            return layer
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setUp()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func updateColor() {
            outermostCircle.backgroundColor = color.cgColor
            middleCircle.backgroundColor = color.cgColor
            innermostCircle.backgroundColor = color.cgColor
        }
        
        private func setUp() {
            backgroundColor = .clear
            
            layer.addSublayer(outermostCircle)
            layer.addSublayer(middleCircle)
            layer.addSublayer(innermostCircle)
        }
        
        public override func layoutSubviews() {
            outermostCircle.frame = bounds
            outermostCircle.cornerRadius = outermostCircle.frame.width / 2
            
            middleCircle.frame = outermostCircle.frame.inset(by: Highlighter.insets)
            middleCircle.cornerRadius = middleCircle.frame.width / 2
            
            innermostCircle.frame = middleCircle.frame.inset(by: Highlighter.insets)
            innermostCircle.cornerRadius = innermostCircle.frame.width / 2
            
            super.layoutSubviews()
        }
        
    }
    
}
