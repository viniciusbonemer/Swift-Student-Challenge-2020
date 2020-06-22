import AVFoundation
import UIKit

public class CameraView: GradientView {
    public var videoName = "Animoji1"
    public var videoExtension = "mov"
    
    public lazy var url = Bundle.main.url(forResource: videoName, withExtension: videoExtension)!
    
    public lazy var playerItem = AVPlayerItem(url: url)
    
    public lazy var queuePlayer: AVQueuePlayer = {
        let player = AVQueuePlayer(items: [playerItem])
        
        return player
    }()
    
    public lazy var playerLayer = AVPlayerLayer(player: queuePlayer)
    
    public var playerLooper: AVPlayerLooper!
    
    public override func didMoveToWindow() {
        playerLooper = AVPlayerLooper(player: queuePlayer,
                                      templateItem: playerItem)
        backgroundColor = .white
        
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
        
        queuePlayer.play()
    }
    
    public override func layoutSubviews() {
        playerLayer.frame = bounds
        
        super.layoutSubviews()
    }
}

