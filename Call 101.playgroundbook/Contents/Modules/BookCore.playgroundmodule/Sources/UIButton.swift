//
//  UIButton.swift
//  
//
//  Created by Vinícius Bonemer on 17/04/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

extension UIButton {
    
    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        var ciImage = CIImage(color: CIColor(color: color))
        ciImage = ciImage.cropped(to: CGRect(x: 0, y: 0, width: 1, height: 1))
        let backgroundImage = UIImage(ciImage: ciImage)
        setBackgroundImage(backgroundImage, for: state)
    }
    
}
