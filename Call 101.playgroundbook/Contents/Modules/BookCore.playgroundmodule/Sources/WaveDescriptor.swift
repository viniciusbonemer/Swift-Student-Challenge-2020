//
//  WaveDescriptor.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 16/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public struct WaveDescriptor {
    
    public var frame: CGRect
    
    @Clamping(min: 0, max: 1)
    public var representedBit: Int = 0
    
    public var yDisloc: CGFloat = 0
    public var xDisloc: CGFloat = 0
    
    public var relativeFrequency: CGFloat?
    public var relativeAmplitude: CGFloat = 1
}
