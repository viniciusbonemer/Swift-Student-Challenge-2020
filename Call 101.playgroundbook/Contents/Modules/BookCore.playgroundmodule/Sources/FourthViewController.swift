//
//  FourthViewController.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 15/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit
import PlaygroundSupport

public class FourthViewController: LiveViewController {

    public var frequencyView: FrequencyView = {
        let view = FrequencyView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    public override func loadView() {
        view = frequencyView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Player.current.startBackgroundMusic()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        frequencyView.oscilloscopeView.showWave()
    }

    public override func receive(_ message: PlaygroundValue) {
        frequencyView.oscilloscopeView.waveScene.startWaveAnimation()
    }
}

