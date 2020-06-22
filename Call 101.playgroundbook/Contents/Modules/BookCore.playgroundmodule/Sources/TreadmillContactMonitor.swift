//
//  TreadmillContactMonitor.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public class TreadmillContactMonitor: ContactMonitor<TreadmillScene> {
    
    public var isContactHappening: Bool { !activeContacts.isEmpty }
    
    private(set) var activeContacts = [Contact]()
    
    public override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        
        var box = Box()
        var treadmill = Treadmill()
        
        do {
            try decompose(contact: contact, body1: &box, body2: &treadmill)
        } catch {
            return
        }
        
        activeContacts.append(Contact(box: box, treadmill: treadmill))
        
        guard box.customColor == treadmill.customColor else {
            scene?.indicateImminentFailure()
            return
        }
        
        scene?.indicateImminentSuccess(for: box)
    }
    
    public override func didEnd(_ contact: SKPhysicsContact) {
        super.didEnd(contact)
        
        var box = Box()
        var treadmill = Treadmill()
        
        do {
            try decompose(contact: contact, body1: &box, body2: &treadmill)
        } catch {
            return
        }
        
        activeContacts.removeAll { $0.box === box && $0.treadmill === treadmill }
        
        scene?.indicateNormality()
    }
    
    public func activeContact(for box: Box) -> Contact? {
        activeContacts.first { $0.box === box }
    }
    
}

extension TreadmillContactMonitor {
    
    public struct Contact {
        weak var box: Box?
        weak var treadmill: Treadmill?
    }
    
}
