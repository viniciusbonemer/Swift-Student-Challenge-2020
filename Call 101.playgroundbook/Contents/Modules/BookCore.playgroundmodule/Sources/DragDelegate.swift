//
//  DragDelegate.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//


public protocol DragDelegate: class {
    
    func draggableNodeShouldBeginDrag(_ node: DraggableNode) -> Bool
    
    func draggableNodeDidBeginDrag(_ node: DraggableNode)
    
    func draggableNodeDidEndDrag(_ node: DraggableNode)
    
}
