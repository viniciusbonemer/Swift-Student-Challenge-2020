//
//  Assets.swift
//  BookCore
//
//  Created by Vinícius Bonemer on 13/05/20.
//

import UIKit

// MARK: - Telephone

public enum Assets { }
    
extension Assets {
    
    private static var wireIconName: String { TelephoneView.DARK ? "WireIcon_white" : "WireIcon" }
    
    public static var wireIcon: UIImage { UIImage(named: Assets.wireIconName)! }
    
    private static var telephoneBackgroundFileName: String { "Page1Background" }
    
    public static var telephoneBackground: UIImage { UIImage(named: Assets.telephoneBackgroundFileName)! }
    
}

// MARK: - Treadmill

extension Assets {
    public enum Treadmill { }
}

extension Assets.Treadmill {
    public enum Size: CaseIterable {
        case short
        case long
    }
}

extension Assets.Treadmill.Size {
    
    fileprivate var prefix: String {
        switch self {
        case .short:
            return "Short"
        case .long:
            return "Long"
        }
    }
    
}

extension Color {
    
    fileprivate var suffix: String { "_\(rawValue)" }
    
}

extension Assets {
    
    private static func treadmillFileName(size: Treadmill.Size, color: Color) -> String {
        "\(size.prefix)Treadmill\(color.suffix)"
    }
    
    public static func treadmill(size: Treadmill.Size, color: Color) -> UIImage {
        let name = treadmillFileName(size: size, color: color)
        let image = UIImage(named: name)!
        return image
    }
    
}

extension Assets {
    
    private static func boxFileName(color: Color) -> String {
        "Box\(color.suffix)"
    }
    
    public static func box(color: Color) -> UIImage {
        let name = boxFileName(color: color)
        let image = UIImage(named: name)!
        return image
    }
    
}
