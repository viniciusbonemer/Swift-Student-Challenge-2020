//
//  Font.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 15/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public enum Font { }

extension Font {
    public enum FrequencyScene { }
}

extension Font.FrequencyScene {
    
    private static var monospacedFontSize: CGFloat { 30 }
    
    public static var monospaced: UIFont {
        .monospacedDigitSystemFont(ofSize: monospacedFontSize, weight: .bold)
    }
    
    private static var defaultFontSize: CGFloat { 30 }
    
    public static var `default`: UIFont {
        .systemFont(ofSize: defaultFontSize, weight: .semibold)
    }
    
}
