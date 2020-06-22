import UIKit
import simd

public class ZerothViewController: UIViewController {
    
    private lazy var pipView: CameraView = {
        let view = CameraView()
        view.topColor = UIColor(hex: 0x3499FF)
        view.bottomColor = UIColor(hex: 0x3A3985)
        view.cornerRadius = 16
        return view
    }()
    
    private var pipPositionViews = [UILayoutGuide]()
    
    private let panRecognizer = UIPanGestureRecognizer()
    
    private var pipPositions: [CGPoint] {
        return pipPositionViews.map { $0.center }
    }
    
    private let pipWidth: CGFloat = 86 * 2
    private let pipHeight: CGFloat = 130 * 2
    
    private let horizontalSpacing: CGFloat = 23 * 2
    private let verticalSpacing: CGFloat = 25 * 2
    
    public override func loadView() {
        let view = CameraView()
        view.videoName = "Animoji2"
        view.cornerRadius = 0
        view.topColor = UIColor(hex: 0xB65EBA)
        view.bottomColor = UIColor(hex: 0x2E8DE1)
//        view.topColor = UIColor(hex: 0xFF28A5)
//        view.bottomColor = UIColor(hex: 0x7934CF)
        
        self.view = view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Player.current.startBackgroundMusic()
        
        view.backgroundColor = UIColor(white: 0.05, alpha: 1)
        
        let topLeftView = addPipPositionView()
        topLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
        topLeftView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing).isActive = true
        
        let topRightView = addPipPositionView()
        topRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
        topRightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing).isActive = true
        
        let bottomLeftView = addPipPositionView()
        bottomLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
        bottomLeftView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalSpacing).isActive = true
        
        let bottomRightView = addPipPositionView()
        bottomRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
        bottomRightView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalSpacing).isActive = true
        
        view.addSubview(pipView)
        pipView.translatesAutoresizingMaskIntoConstraints = false
        pipView.widthAnchor.constraint(equalToConstant: pipWidth).isActive = true
        pipView.heightAnchor.constraint(equalToConstant: pipHeight).isActive = true
        
        panRecognizer.addTarget(self, action: #selector(pipPanned(recognizer:)))
        pipView.addGestureRecognizer(panRecognizer)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pipView.center = pipPositions.last ?? .zero
    }
    
    private func addPipPositionView() -> UILayoutGuide {
        let view = UILayoutGuide()
        //        self.view.addSubview(view)
        self.view.addLayoutGuide(view)
        pipPositionViews.append(view)
        //        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: pipWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: pipHeight).isActive = true
        return view
    }
    
    private var initialOffset: CGPoint = .zero
    
    @objc private func pipPanned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            initialOffset = CGPoint(x: touchPoint.x - pipView.center.x, y: touchPoint.y - pipView.center.y)
        case .changed:
            pipView.center = CGPoint(x: touchPoint.x - initialOffset.x, y: touchPoint.y - initialOffset.y)
        case .ended, .cancelled:
            let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
            let velocity = recognizer.velocity(in: view)
            let projectedPosition = CGPoint(
                x: pipView.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
                y: pipView.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
            )
            let nearestCornerPosition = nearestCorner(to: projectedPosition)
            let relativeInitialVelocity = CGVector(
                dx: relativeVelocity(forVelocity: velocity.x, from: pipView.center.x, to: nearestCornerPosition.x),
                dy: relativeVelocity(forVelocity: velocity.y, from: pipView.center.y, to: nearestCornerPosition.y)
            )
            let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4, initialVelocity: relativeInitialVelocity)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.pipView.center = nearestCornerPosition
            }
            animator.startAnimation()
        default: break
        }
    }
    
    /// Distance traveled after decelerating to zero velocity at a constant rate.
    private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
    }
    
    /// Finds the position of the nearest corner to the given point.
    private func nearestCorner(to point: CGPoint) -> CGPoint {
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestPosition = CGPoint.zero
        for position in pipPositions {
            let distance = CGFloat(simd_distance(SIMD2(Double(position.x), Double(position.y)), SIMD2(Double(point.x), Double(point.y))))
            if distance < minDistance {
                closestPosition = position
                minDistance = distance
            }
        }
        return closestPosition
    }
    
    /// Calculates the relative velocity needed for the initial velocity of the animation.
    private func relativeVelocity(forVelocity velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
        guard currentValue - targetValue != 0 else { return 0 }
        return velocity / (targetValue - currentValue)
    }
    
}
