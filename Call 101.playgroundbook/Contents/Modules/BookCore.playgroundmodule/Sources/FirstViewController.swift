//
//  FirstViewController.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 11/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import AVFoundation
import UIKit
import PlaygroundSupport

public class FirstViewController : LiveViewController {
    
    static private var ringTimes: [Int] {
        [1, 4, 6, 7, 7]
    }
    
    private lazy var telephoneView: TelephoneView = {
        let view = TelephoneView()
        
        view.backgroundColor = .white
        view.connectionDelegate = self
        view.maximumNumberOfConnections = 3
        
        return view
    }()
    
    private lazy var players: [AVAudioPlayer] = {
        var players = [AVAudioPlayer]()
        
        for i in 0 ..< FirstViewController.ringTimes.count {
            let url = Ressources.ringToneURL
            
            let player = try! AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            
            players.append(player)
        }
        
        return players
    }()
    
    private var timer: Timer?
    
    public override func loadView() {
        self.view = telephoneView
    }
    
    public override func viewDidLoad() {
//        startGame()
        Player.current.startBackgroundMusic()
    }
    
    @objc
    private func endGame() {
        let message = "### Well done! We can move on!"
        let link = "\n\n[**Next page**](@next)"
        PlaygroundPage.current.assessmentStatus = .pass(message: "\(message)\(link)")
    }
    
    public func startGame() {
        
        for (index, connector) in telephoneView.leftConnectors.shuffled().enumerated() {
            connector.tag = index
            let ringTime = FirstViewController.ringTimes[index]
            let player = players[index]
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(ringTime)) { [weak connector] in
                connector?.startRinging()
                player.play()
            }
        }
    }
    
    override public func receive(_ message: PlaygroundValue) {
        startGame()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        view.setNeedsUpdateConstraints()
    }
}

extension FirstViewController: ConnectionDelegate {
    
    public func connectionSucceededBetween(leftConnector: ConnectorView, rightConnector: ConnectorView) {
        let index = leftConnector.tag
        let player = players[index]
        player.stop()
        Player.current.playSuccessSound()
        
        guard telephoneView.availableWireCount == 0 else { return }
        timer = Timer.scheduledTimer(timeInterval: 2,
                                     target: self, selector: #selector(endGame),
                                     userInfo: nil, repeats: false)
    }
    
    public func connectionFailedBetween(leftConnector: ConnectorView, rightConnector: ConnectorView?) {
        if telephoneView.availableWireCount == 0 {
            // Cannot connect
            Player.current.playFailureSound()
        }
    }
}
