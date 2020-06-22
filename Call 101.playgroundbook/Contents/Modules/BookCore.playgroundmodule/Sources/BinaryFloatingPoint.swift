//
//  BinaryFloatingPoint.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 16/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

extension BinaryFloatingPoint {
    
    public func mapped(from oldRange: ClosedRange<Self>, to newRange: ClosedRange<Self>) -> Self {
        let normalized = (self - oldRange.lowerBound) / (oldRange.upperBound - oldRange.lowerBound)
        return newRange.lowerBound + (newRange.upperBound - newRange.lowerBound) * (normalized)
    }
    
}
