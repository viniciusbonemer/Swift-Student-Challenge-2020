//
//  ConnectionDelegate.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 12/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import Foundation

public protocol ConnectionDelegate: class {
    
    func connectionSucceededBetween(leftConnector: ConnectorView, rightConnector: ConnectorView)
    
    func connectionFailedBetween(leftConnector: ConnectorView, rightConnector: ConnectorView?)
    
}
