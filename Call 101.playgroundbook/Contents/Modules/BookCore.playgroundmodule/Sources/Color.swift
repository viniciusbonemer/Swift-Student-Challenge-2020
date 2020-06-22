//
//  Color.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 11/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public enum Color: String, CaseIterable {
    case red
    case purple
    case orange
    case green
    case blue
    case gray
}

extension Color {
    
    public var endPoint: UIColor {
        switch self {
        case .red:
            return UIColor(hex: 0xFF4F4F)
        case .purple:
            return UIColor(hex: 0x7D33F3)//UIColor(hex: 0x4C33F3)
        case .orange:
            return UIColor(hex: 0xFDA617)
        case .green:
            return UIColor(hex: 0x3FB215)
        case .blue:
            return UIColor(hex: 0x11B2DC)
        case .gray:
            return .black
        }
    }
    
    public var treadmill: UIColor {
        switch self {
        case .red:
            return UIColor(hex: 0xFF9494)
        case .purple:
            return UIColor(hex: 0xC4BCF8)
        case .orange:
            return UIColor(hex: 0xFDCF83)
        case .green:
            return UIColor(hex: 0x99CD86)
        case .blue:
            return UIColor(hex: 0x8FD0E0)
        case .gray:
            return UIColor(hex: 0xD8D8D8)
        }
    }
    
    public var lightFeedback: UIColor {
        switch self {
        case .red:
            return UIColor(hex: 0xFF9494)
        case .green:
            return UIColor(hex: 0x99CD86)
        default:
            return .black
        }
    }
    
    public var strongFeedback: UIColor {
        switch self {
        case .red:
            return UIColor(hex: 0xFF7575)
        case .green:
            return UIColor(hex: 0x90FF68)
        default:
            return .black
        }
    }
    
}
