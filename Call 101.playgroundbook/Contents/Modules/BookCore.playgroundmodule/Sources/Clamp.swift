//
//  Clamp.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 14/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

public extension BinaryFloatingPoint {
    
    func clamped(to range: ClosedRange<Self>) -> Self {
        max(range.lowerBound, min(range.upperBound, self))
    }
    
    mutating func clamp(to range: ClosedRange<Self>) {
        self = self.clamped(to: range)
    }
    
}

public extension BinaryInteger {
    
    func clamped(to range: ClosedRange<Self>) -> Self {
        max(range.lowerBound, min(range.upperBound, self))
    }
    
    mutating func clamp(to range: ClosedRange<Self>) {
        self = self.clamped(to: range)
    }
    
}
