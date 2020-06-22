//
//  UIColor.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 11/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(hex: UInt) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >>  8) / 255.0
        let b = CGFloat((hex & 0x0000FF) >>  0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(1.0))
    }
}

