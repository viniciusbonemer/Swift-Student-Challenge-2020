//
//  NSLayoutConstraints.swift
//  
//
//  Created by Vinícius Bonemer on 14/02/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    public func identified(by identifier: String) -> Self {
        self.identifier = identifier
        return self
    }
    
    public func withPriority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
    
}
