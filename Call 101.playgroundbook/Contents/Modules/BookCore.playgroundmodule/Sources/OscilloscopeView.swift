//
//  OscilloscopeView.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 15/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit
import SpriteKit

public class OscilloscopeView: UIView {
    
    private lazy var internalShadow: InternalShadowView = {
        let view = InternalShadowView()
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    private lazy var waveView: WaveView = {
//        let view = WaveView()
//
//        view.backgroundColor = .clear
//        view.waveColor = UIColor(hex: 0x111111)
//        view.waveWidth = 2
//        view.isUserInteractionEnabled = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
    
    private lazy var waveView: SKView = {
        let view = SKView()
        
        view.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var waveScene: WaveScene = WaveScene(size: bounds.size)
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
    }
    
    public override func didMoveToWindow() {
        setUpConstraints()
    }
    
    public func showWave() {
        waveScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        waveScene.scaleMode = .aspectFill
        waveView.presentScene(waveScene)
    }
    
    private func setUp() {
        setUpViewHierarchy()
        isUserInteractionEnabled = true
    }
    
    private func setUpViewHierarchy() {
        addSubview(internalShadow)
        addSubview(waveView)
    }
    
    private func setUpConstraints() {
        internalShadow.pin(to: self)
        waveView.pin(to: self, with: UIEdgeInsets(top: 10, left: 0,
                                                  bottom: 10, right: 0))
    }
    
//    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        (waveView.scene as! WaveScene).wave.shouldStopAnimating = true
//    }
}
