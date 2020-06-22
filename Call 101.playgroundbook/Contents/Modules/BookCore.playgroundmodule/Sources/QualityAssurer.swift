//
//  QualityAssurer.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

class QualityAssurer {
    
    weak var scene: TreadmillScene?
    
    weak var misplacedNode: DraggableNode?
    
    var nodeOriginalZPosition: CGFloat = 0
    
    private var contactMonitor: TreadmillContactMonitor
    
    init() {
        self.contactMonitor = TreadmillContactMonitor()
    }
    
    func start(on scene: TreadmillScene) {
        self.scene = scene
        contactMonitor.startMonitoringScene(scene)
    }
    
}

extension QualityAssurer: DragDelegate {
    
    public func draggableNodeShouldBeginDrag(_ node: DraggableNode) -> Bool {
        // Should never happen
        guard let box = node as? Box else { return false }
        // No misplaced nodes... Let it drag
        if misplacedNode == nil { return true }
        // There's a misplaced node. Can only drag the misplaced node
        guard box === misplacedNode else {
            scene?.indicateFailure()
            return false
        }
        return true
    }
    
    public func draggableNodeDidBeginDrag(_ node: DraggableNode) {
        node.removeAllActions()
        nodeOriginalZPosition = node.zPosition
        node.zPosition = TreadmillScene.Layer.draggedNode.zPosition
        
        misplacedNode = nil
        scene?.indicateNormality()
    }
    
    public func draggableNodeDidEndDrag(_ node: DraggableNode) {
        node.zPosition = nodeOriginalZPosition
        nodeOriginalZPosition = 0
        
        guard
            let box = node as? Box,
            let contact = contactMonitor.activeContact(for: box),
            let treadmill = contact.treadmill
            else {
                // There are contacts, but not with this box
                misplacedNode = node
                scene?.indicateFailure()
                return
        }
        
        guard box.customColor == treadmill.customColor else {
            // Wrong treadmill
            misplacedNode = box
            scene?.indicateFailure()
            return
        }
        
        // Right treadmill
        scene?.indicateSuccess(for: box)
        scene?.didPlaceBox(box, on: treadmill)
    }
}
