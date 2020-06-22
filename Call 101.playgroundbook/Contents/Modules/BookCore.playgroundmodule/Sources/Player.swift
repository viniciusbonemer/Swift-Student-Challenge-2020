//
//  Player.swift
//  LiveViewTestApp
//
//  Created by Vinícius Bonemer on 18/05/20.
//

import AVFoundation

public final class Player {
    
    public static let current = Player()
    
    private var successSoundPlayer: AVAudioPlayer = {
        let url = Ressources.successSoundURL
        
        let player = try! AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = 0
        player.setVolume(0.5, fadeDuration: 0)
        return player
    }()
    
    private var failureSoundPlayer: AVAudioPlayer = {
        let url = Ressources.failureSoundURL
        
        let player = try! AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = 0
        player.setVolume(1, fadeDuration: 0)
        return player
    }()
    
    private var backgroundMusicPlayer: AVAudioPlayer = {
        let url = Ressources.backgroundMusicURL
        
        let player = try! AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = -1
        player.setVolume(0.3, fadeDuration: 0)
        
        return player
    }()
    
    private init() { }
    
    public func playSuccessSound() {
        successSoundPlayer.play()
    }
    
    public func playFailureSound() {
        failureSoundPlayer.play()
    }
    
    public func startBackgroundMusic() {
        backgroundMusicPlayer.play()
    }
    
}
