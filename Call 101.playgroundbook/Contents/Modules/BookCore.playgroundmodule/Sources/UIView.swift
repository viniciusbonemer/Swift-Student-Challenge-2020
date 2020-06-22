//
//  UIView.swift
//  
//
//  Created by Vinícius Bonemer on 17/04/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

extension UIView {
    
    func activateDebugFrame(width: CGFloat = 2, color: UIColor = .red) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    @discardableResult
    func withDebugFrame(width: CGFloat = 2, color: UIColor = .red) -> Self {
        activateDebugFrame(width: width, color: color)
        return self
    }
    
}

extension UIView {
    
    public func pin(to other: UIView, with insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top),
            self.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.right),
            self.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom),
        ])
    }
    
    public func pin(to other: UILayoutGuide, with insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top),
            self.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.right),
            self.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom),
        ])
    }
    
}
