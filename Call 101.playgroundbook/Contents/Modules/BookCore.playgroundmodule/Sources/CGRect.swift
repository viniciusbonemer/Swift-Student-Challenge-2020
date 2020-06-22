//
//  File.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 14/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import struct CoreGraphics.CGRect
import struct CoreGraphics.CGPoint

public extension CGRect {
    
    var center: CGPoint { CGPoint(x: midX, y: midY) }
    
}
