//
//  ThirdViewController.swift
//  BookCore
//
//  Created by Vinícius Bonemer on 16/05/20.
//

import AVFoundation
import UIKit
import PlaygroundSupport

public class ThirdViewController: LiveViewController {
    
    let videoName = "Animation.mov"
    
    lazy var url = Bundle.main.url(forResource: videoName, withExtension: nil)!
    
    lazy var playerItem = AVPlayerItem(url: url)
    
    lazy var queuePlayer: AVQueuePlayer = {
        let player = AVQueuePlayer(items: [playerItem])
        
        return player
    }()
    
    lazy var playerLayer = AVPlayerLayer(player: queuePlayer)
    
    var playerLooper: AVPlayerLooper!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Player.current.startBackgroundMusic()
        
        playerLooper = AVPlayerLooper(player: queuePlayer,
                                      templateItem: playerItem)
        view.backgroundColor = .white
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
    }
    
    public override func viewDidLayoutSubviews() {
        playerLayer.frame = view.bounds
    }
    
    public override func receive(_ message: PlaygroundValue) {
        queuePlayer.play()
    }
}
