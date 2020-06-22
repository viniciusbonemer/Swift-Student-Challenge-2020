//
//  SecondViewController.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 13/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit
import SpriteKit
import PlaygroundSupport

public class SecondViewController: LiveViewController {

    private lazy var skView: SKView = {
        let view = SKView()
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var scene: TreadmillScene = {
        let scene = TreadmillScene(size: TreadmillScene.defaultSize)
        
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        scene.endDelegate = self
        
        return scene
    }()
    
    public override func loadView() {
        let view = GradientView()
        
        view.backgroundColor = .white
        view.cornerRadius = 0
        view.topColor = UIColor(hex: 0xEEEEEE)
        view.bottomColor = UIColor(hex: 0xD3D3D3)//UIColor(hex: 0x2D3436)
        view.gradientLayer.opacity = 0.6
        
        
        view.addSubview(skView)
        
        self.view = view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Player.current.startBackgroundMusic()
        
        setUpConstraints()
        
        view.backgroundColor = .clear
        skView.presentScene(scene)
    }
    
    private func setUpConstraints() {
        skView.pin(to: view)
    }
    
    override public func receive(_ message: PlaygroundValue) {
        scene.start()
    }

}

extension SecondViewController: TreadmillSceneEndDelegate {
    
    public func sceneDidEnd(_ scene: TreadmillScene) {
        let message = "### You delivered all messages! \nLet's see what's next!"
        let link = "\n\n[**Next page**](@next)"
        PlaygroundPage.current.assessmentStatus = .pass(message: "\(message)\(link)")
    }
    
}
