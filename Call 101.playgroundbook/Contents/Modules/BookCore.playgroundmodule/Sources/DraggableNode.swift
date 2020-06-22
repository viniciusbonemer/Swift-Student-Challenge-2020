//
//  DraggableNode.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public class DraggableNode: SKSpriteNode {
    
    private var firstTouchLocation: CGPoint?
    private var startPosition: CGPoint?
    
    private var isBeingDragged: Bool { startPosition != nil }
    
    public weak var dragDelegate: DragDelegate?
    
    public override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
    }
    
    public func dragBegan() {
        dragDelegate?.draggableNodeDidBeginDrag(self)
    }
    
    public func dragEnded() {
        dragDelegate?.draggableNodeDidEndDrag(self)
    }
    
    public final override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let parent = parent,
            let touch = touches.first
            else { return }
        
        guard dragDelegate?.draggableNodeShouldBeginDrag(self) ?? true else { return }
        
        let location = touch.location(in: parent)
        firstTouchLocation = location
        startPosition = position
        
        dragBegan()
    }
    
    public final override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let parent = parent,
            let startPosition = startPosition,
            let touch = touches.first
            else { return }
        
        let location = touch.location(in: parent)
        let delta = CGPoint(x: location.x - startPosition.x,
                            y: location.y - startPosition.y)
        
        position = CGPoint(x: startPosition.x + delta.x,
                           y: startPosition.y + delta.y)
    }
    
    public final override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            firstTouchLocation = nil
            startPosition = nil
        }
        
        guard isBeingDragged else { return }
        dragEnded()
    }
    
    public final override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            firstTouchLocation = nil
            startPosition = nil
        }
        
        guard let startPosition = startPosition else { return }
        position = startPosition
        
        guard isBeingDragged else { return }
        dragEnded()
    }
    
}
