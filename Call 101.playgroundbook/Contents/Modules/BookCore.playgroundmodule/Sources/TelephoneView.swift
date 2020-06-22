//
//  TelephoneView.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 11/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public class TelephoneView: GradientView {
    
    public static var DARK: Bool { false }
    
    private static var colors: [UIColor] {
        Color.allCases
            .filter { $0 != .gray }
            .map { $0.endPoint }
    }
    
    private static var connectorsCount: Int { colors.count }
    
    private static var wireIconSizeConstraintIdentifier: String {
        "wireIconSizeConstraintIdentifier"
    }
    
    var maximumNumberOfConnections: Int {
        get { ConnectionManager.maximumNumberOfActiveConnectors }
        set { ConnectionManager.maximumNumberOfActiveConnectors = newValue }
    }
    
    public var connectionDelegate: ConnectionDelegate? {
        get {
            connectionManager.connectionDelegate
        }
        set {
            connectionManager.connectionDelegate = newValue
        }
    }
    
    private lazy var background: UIImageView = {
        let view = UIImageView(image: Assets.telephoneBackground)
        
        view.contentMode = .scaleAspectFill
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var connectionManager = ConnectionManager()
    
    public lazy var leftConnectors = [ConnectorView]()

    public lazy var rightConnectors = [ConnectorView]()
    
    public  var availableWires: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .top
        stack.backgroundColor = .orange
        
        let icon = Assets.wireIcon
        
        for i in 0 ..< ConnectionManager.maximumNumberOfActiveConnectors {
            let wire = UIImageView(image: icon)
            wire.tintColor = .lightGray
            
            wire.translatesAutoresizingMaskIntoConstraints = false
            
            stack.addArrangedSubview(wire)
        }
        
        return stack
    }()
    
    public var mapping: [Int : Int] = {
        let left = Array(0..<TelephoneView.connectorsCount)
        let right = Array(0..<TelephoneView.connectorsCount).shuffled()
        
        return left.reduce(Dictionary()) { (result, l) in
            var next = result
            next[l] = right[l]
            return next
        }
    }()
    
    private var _availableWireCount: Int = ConnectionManager.maximumNumberOfActiveConnectors
    
    public var availableWireCount: Int {
        get {
            _availableWireCount
        }
        set {
            _availableWireCount = newValue
            
            updateWireIcons(forAvailableConnections: newValue)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToWindow() {
        setUpConstraints()
    }
    
    private func updateWireIcons(forAvailableConnections count: Int) {
        for i in 0 ..< ConnectionManager.maximumNumberOfActiveConnectors {
            guard let imageView = availableWires.arrangedSubviews[i] as? UIImageView else { continue }
            if i < count {
                imageView.image = imageView.image?.withRenderingMode(.alwaysOriginal)
            } else if i == count {
                
                let constraints = imageView.constraints.filter {
                    $0.identifier == TelephoneView.wireIconSizeConstraintIdentifier
                    }
                let constants = constraints.map { $0.constant }
                
                constraints.forEach { $0.constant *= 1.2 }
                
                let growAnimation: () -> Void = { [weak imageView] in
                    imageView?.superview?.layoutIfNeeded()
                }
                
                let shrinkAnimation: () -> Void = { [weak imageView] in
                    imageView?.alpha = 0.5
                    imageView?.superview?.layoutIfNeeded()
                }
                
                let updateRenderingMode: (Bool) -> Void = { [weak imageView] _ in
                    imageView?.image = imageView?.image?.withRenderingMode(.alwaysTemplate)
                }
                
                let updateConstraintsThenShrink: (Bool) -> Void = { _ in
                    constraints.enumerated().forEach { (i, constraint) in
                        constraint.constant = constants[i]
                    }
                    
                    UIView.animate(withDuration: 0.5,
                                   delay: 0.2,
                                   options: .curveEaseInOut,
                                   animations: shrinkAnimation,
                                   completion: updateRenderingMode)
                }
                
                UIView.animate(withDuration: 0.5,
                               animations: growAnimation,
                               completion: updateConstraintsThenShrink)
            } else {
                imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    private func setUp() {
        cornerRadius = 0
        backgroundColor = .white
        topColor = UIColor(hex: 0xFCE38A)
        bottomColor = UIColor(hex: 0xF38181)
        gradientLayer.opacity = 0.6
        
        createConnectors()
        setUpViewHierarchy()
        connectionManager.setUp(in: self)
    }
    
    private func setUpViewHierarchy() {
        if TelephoneView.DARK { addSubview(background) }
        
        for connector in leftConnectors {
            addSubview(connector)
        }

        for connector in rightConnectors {
            addSubview(connector)
        }
        
        addSubview(availableWires)
    }
    
    private func createConnectors() {
        leftConnectors.reserveCapacity(TelephoneView.connectorsCount)
        rightConnectors.reserveCapacity(TelephoneView.connectorsCount)

        for i in 0 ..< TelephoneView.connectorsCount {
            let leftConnector = ConnectorView()
            let rightConnector = ConnectorView()

            leftConnector.translatesAutoresizingMaskIntoConstraints = false
            rightConnector.translatesAutoresizingMaskIntoConstraints = false
            
            leftConnector.showsLeadingEndPoint = false
            rightConnector.showsTrailingEndPoint = false
            
            let colorIndex = mapping[i]!
            let rightColor = TelephoneView.colors[colorIndex]
            rightConnector.leadingEndPointColor = rightColor
            leftConnector.trailingEndPointHighlightColor = rightColor

            leftConnectors.append(leftConnector)
            rightConnectors.append(rightConnector)
        }
    }
    
    // MARK: Constraints
    
    private func setUpConstraints() {
        if TelephoneView.DARK {
            NSLayoutConstraint.activate([
                background.topAnchor.constraint(equalTo: topAnchor),
                background.leadingAnchor.constraint(equalTo: leadingAnchor),
                background.trailingAnchor.constraint(equalTo: trailingAnchor),
                background.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            availableWires.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                constant: 12),
            availableWires.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                    constant: 10)
        ])
        
        for icon in availableWires.arrangedSubviews {
            NSLayoutConstraint.activate([
                icon.widthAnchor.constraint(equalToConstant: 60)
                    .identified(by: TelephoneView.wireIconSizeConstraintIdentifier),
                icon.heightAnchor.constraint(equalToConstant: 60)
                    .identified(by: TelephoneView.wireIconSizeConstraintIdentifier)
            ])
        }
        
        let centerGuide = UILayoutGuide()
        addLayoutGuide(centerGuide)
        
        NSLayoutConstraint.activate([
            centerGuide.topAnchor.constraint(equalTo: topAnchor),
            centerGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            centerGuide.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerGuide.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ])
        
        let leftWrapper = UILayoutGuide()
        addLayoutGuide(leftWrapper)
        
        NSLayoutConstraint.activate([
            leftWrapper.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftWrapper.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            leftWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftWrapper.trailingAnchor.constraint(equalTo: centerGuide.leadingAnchor)
        ])
        
        if let first = leftConnectors.first {
            first.topAnchor.constraint(equalTo: leftWrapper.topAnchor).isActive = true
        }
        
        for i in 0 ..< (leftConnectors.count - 1) {
            let current = leftConnectors[i]
            let next = leftConnectors[i + 1]
            
            NSLayoutConstraint.activate([
                current.leadingEndPointAnchor.constraint(equalTo: leftWrapper.leadingAnchor),
                current.trailingEndPointAnchor.constraint(equalTo: leftWrapper.trailingAnchor),
                current.bottomAnchor.constraint(equalTo: next.topAnchor),
                current.heightAnchor.constraint(equalTo: next.heightAnchor)
            ])
        }
        
        if let last = leftConnectors.last {
            NSLayoutConstraint.activate([
                last.leadingEndPointAnchor.constraint(equalTo: leftWrapper.leadingAnchor),
                last.trailingEndPointAnchor.constraint(equalTo: leftWrapper.trailingAnchor),
                last.bottomAnchor.constraint(equalTo: leftWrapper.bottomAnchor)
            ])
        }
        
        let rightWrapper = UILayoutGuide()
        addLayoutGuide(rightWrapper)
        
        NSLayoutConstraint.activate([
            rightWrapper.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightWrapper.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            rightWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightWrapper.leadingAnchor.constraint(equalTo: centerGuide.trailingAnchor)
        ])
        
        if leftConnectors.count >= 1 {
            let firstIndex = mapping[0]!
            let first = rightConnectors[firstIndex]
            first.topAnchor.constraint(equalTo: rightWrapper.topAnchor).isActive = true
        }
        
        for i in 0 ..< (rightConnectors.count - 1) {
            let currentIndex = mapping[i]!
            let nextIndex = mapping[i + 1]!
            
            let current = rightConnectors[currentIndex]
            let next = rightConnectors[nextIndex]
            
            NSLayoutConstraint.activate([
                current.leadingEndPointAnchor.constraint(equalTo: rightWrapper.leadingAnchor),
                current.trailingEndPointAnchor.constraint(equalTo: rightWrapper.trailingAnchor),
                current.bottomAnchor.constraint(equalTo: next.topAnchor),
                current.heightAnchor.constraint(equalTo: next.heightAnchor)
            ])
        }
        
        if leftConnectors.count >= 1 {
            let lastIndex = mapping[leftConnectors.count - 1]!
            let last = rightConnectors[lastIndex]
            
            NSLayoutConstraint.activate([
                last.leadingEndPointAnchor.constraint(equalTo: rightWrapper.leadingAnchor),
                last.trailingEndPointAnchor.constraint(equalTo: rightWrapper.trailingAnchor),
                last.bottomAnchor.constraint(equalTo: rightWrapper.bottomAnchor)
            ])
        }
    }
    
}

extension TelephoneView {
    
    fileprivate class ConnectionManager {
        
        weak var view: TelephoneView?
        
        public weak var connectionDelegate: ConnectionDelegate?
        
        private var panRecognizer = UIPanGestureRecognizer()
        
        fileprivate func setUp(in view: TelephoneView) {
            self.view = view
            
            panRecognizer.addTarget(self, action: #selector(recognizerDidPan(_:)))
            self.view?.addGestureRecognizer(panRecognizer)
        }
        
        private var origin: ConnectorView?
        
        private var destination: ConnectorView?
        
        private var currentConnector: ConnectorView?
        
        private var temporaryReferenceView: UIView?
        
        private var temporaryReferenceViewXPositionConstraint: NSLayoutConstraint?
        
        private var temporaryReferenceViewYPositionConstraint: NSLayoutConstraint?
        
        private var activeConnectors = [ConnectorView]()
        
        private var connections: [Int : Int] = [:]
        
        static var maximumNumberOfActiveConnectors: Int = 3
        
        @objc
        private func recognizerDidPan(_ recognizer: UIPanGestureRecognizer) {
            switch recognizer.state {
            case .began:
                recognizerDidBegin(recognizer)
            case .changed:
                recognizerDidMove(recognizer)
            case .ended:
                recognizerDidEnd(recognizer)
            case .cancelled, .failed:
                recognizerDidCancel(recognizer)
            default:
                return
            }
        }
        
        private func recognizerDidBegin(_ recognizer: UIPanGestureRecognizer) {
            guard let view = view else { return }
            
            // Used to attract connection when is near
            let minDistance: CGFloat
            
            if view.leftConnectors.count >= 2 {
                // a little less than half of dist between connectors
                minDistance = abs(view.leftConnectors[1].center.y - view.leftConnectors[0].center.y) * 0.4
            } else {
                minDistance = 15
            }
            
            guard let origin = view.leftConnectors.first(where: { (leftConnector) in
                
                let location = recognizer.location(in: leftConnector)
                let hitArea = leftConnector.trailingEndPoint.frame
                    .inset(by: UIEdgeInsets(top: -minDistance, left: -minDistance,
                                            bottom: -minDistance, right: -minDistance))
                return hitArea.contains(location)
            }) else { return }
            
            guard
                let index = view.leftConnectors.firstIndex(of: origin),
                !connections.keys.contains(index) else {
                    // Invalid connection attempt
                    connectionDelegate?.connectionFailedBetween(leftConnector: origin, rightConnector: nil)
                    return
            }
            
            guard connections.count < ConnectionManager.maximumNumberOfActiveConnectors else {
                // Invalid connection attempt
                connectionDelegate?.connectionFailedBetween(leftConnector: origin, rightConnector: nil)
                return
            }
            
            guard origin.isRinging else {
                // Invalid connection attempt
                connectionDelegate?.connectionFailedBetween(leftConnector: origin, rightConnector: nil)
                return
            }
            
            self.origin = origin
            
            currentConnector = {
                let connector = ConnectorView()
                
                connector.leadingEndPointColor = .darkGray
                connector.trailingEndPointColor = .darkGray
                connector.canTilt = true
                
                view.addSubview(connector)
                
                NSLayoutConstraint.activate([
                    connector.leadingEndPoint.centerXAnchor.constraint(equalTo: origin.trailingEndPoint.centerXAnchor),
                    connector.leadingEndPoint.centerYAnchor.constraint(equalTo: origin.trailingEndPoint.centerYAnchor)
                ])
                
                connector.translatesAutoresizingMaskIntoConstraints = false
                
                return connector
            }()
            
            temporaryReferenceView = {
                let tempView = UIView()
                tempView.backgroundColor = .clear
                tempView.translatesAutoresizingMaskIntoConstraints = false
                
                view.insertSubview(tempView, belowSubview: currentConnector!)
                
                NSLayoutConstraint.activate([
                    tempView.centerXAnchor.constraint(equalTo: currentConnector!.trailingEndPoint.centerXAnchor),
                    tempView.centerYAnchor.constraint(equalTo: currentConnector!.trailingEndPoint.centerYAnchor),
                    tempView.heightAnchor.constraint(equalTo: currentConnector!.trailingEndPoint.heightAnchor),
                    tempView.widthAnchor.constraint(equalTo: currentConnector!.trailingEndPoint.widthAnchor)
                ])
                
                return tempView
            }()
            
            let p = recognizer.location(in: view)
            temporaryReferenceViewXPositionConstraint = temporaryReferenceView!.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: p.x)
            temporaryReferenceViewYPositionConstraint = temporaryReferenceView!.centerYAnchor.constraint(equalTo: view.topAnchor, constant: p.y)
            
            NSLayoutConstraint.activate([temporaryReferenceViewYPositionConstraint!,
                                         temporaryReferenceViewXPositionConstraint!])
        }
        
        private func recognizerDidMove(_ recognizer: UIPanGestureRecognizer) {
            guard
                let origin = origin,
                let view = view
                else { return }
            
            // Used to attract connection when is near
            let minDistance: CGFloat
            
            if view.leftConnectors.count >= 2 {
                // a little less than half of dist between connectors
                minDistance = abs(view.leftConnectors[1].center.y - view.leftConnectors[0].center.y) * 0.4
            } else {
                minDistance = 15
            }
            
            defer {
                view.setNeedsLayout()
            }
            
            guard let finalConnector = view.rightConnectors.enumerated()
                .first(where: { (index, rightConnector) in
                    // Make sure this is not connected yet
                    guard !connections.values.contains(index) else { return false }
                    
                    let location = recognizer.location(in: rightConnector)
                    let hitArea = rightConnector.leadingEndPoint.frame
                        .inset(by: UIEdgeInsets(top: -minDistance, left: -minDistance,
                                                bottom: -minDistance, right: -minDistance))
                    return hitArea.contains(location)
                })?.element else {
                    // Not near any connector
                    let p = recognizer.location(in: view)
                    temporaryReferenceViewXPositionConstraint?.constant = p.x
                    temporaryReferenceViewYPositionConstraint?.constant = p.y
                    destination = nil
                    return
            }
            
            // Make sure that this is the right one
            guard
                let leftIndex = view.leftConnectors.firstIndex(of: origin),
                let rightIndex = view.rightConnectors.firstIndex(of: finalConnector),
                leftIndex == rightIndex else {
                    // Invalid connection
                    let p = recognizer.location(in: view)
                    temporaryReferenceViewXPositionConstraint?.constant = p.x
                    temporaryReferenceViewYPositionConstraint?.constant = p.y
                    destination = nil
                    return
            }
            
            destination = finalConnector
            
            let p = view.convert(finalConnector.leadingEndPoint.center, from: finalConnector)
            temporaryReferenceViewXPositionConstraint?.constant = p.x
            temporaryReferenceViewYPositionConstraint?.constant = p.y
            view.setNeedsLayout()
        }
        
        private func recognizerDidEnd(_ recognizer: UIPanGestureRecognizer) {
            defer {
                self.origin = nil
                self.destination = nil
                self.currentConnector = nil
                self.temporaryReferenceViewXPositionConstraint?.isActive = false
                self.temporaryReferenceViewYPositionConstraint?.isActive = false
            }
            
            self.temporaryReferenceViewXPositionConstraint = nil
            self.temporaryReferenceViewYPositionConstraint = nil
            self.temporaryReferenceView?.removeFromSuperview()
            self.temporaryReferenceView = nil
            
            guard
                let view = view,
                let currentConnector = currentConnector,
                let origin = origin
                else {
                    self.currentConnector?.removeFromSuperview()
                    return
            }
            
            guard let destination = destination else {
                self.currentConnector?.removeFromSuperview()
                
                let minDistance: CGFloat
                
                if view.leftConnectors.count >= 2 {
                    // a little less than half of dist between connectors
                    minDistance = abs(view.leftConnectors[1].center.y - view.leftConnectors[0].center.y) * 0.4
                } else {
                    minDistance = 15
                }
                
                let destination = view.rightConnectors.enumerated()
                    .first(where: { (index, rightConnector) in
                        // Make sure this is not connected yet
                        guard !connections.values.contains(index) else { return false }
                        
                        let location = recognizer.location(in: rightConnector)
                        let hitArea = rightConnector.leadingEndPoint.frame
                            .inset(by: UIEdgeInsets(top: -minDistance, left: -minDistance,
                                                    bottom: -minDistance, right: -minDistance))
                        return hitArea.contains(location)
                    })?.element
                
                connectionDelegate?.connectionFailedBetween(leftConnector: origin, rightConnector: destination)
                
                return
            }
            
            let key = view.leftConnectors.firstIndex(of: origin)!
            let value = view.rightConnectors.firstIndex(of: destination)!
            
            connections[key] = value
            origin.stopRinging()
            
            currentConnector.leadingEndPointColor = destination.leadingEndPointColor
            currentConnector.trailingEndPointColor = destination.leadingEndPointColor
            
            NSLayoutConstraint.activate([
                currentConnector.trailingEndPoint.centerXAnchor.constraint(equalTo: destination.leadingEndPoint.centerXAnchor),
                currentConnector.trailingEndPoint.centerYAnchor.constraint(equalTo: destination.leadingEndPoint.centerYAnchor)
            ])
            
            let availableWires = ConnectionManager.maximumNumberOfActiveConnectors - connections.count
            
            view.availableWireCount = availableWires
            connectionDelegate?.connectionSucceededBetween(leftConnector: origin, rightConnector: destination)
        }
        
        private func recognizerDidCancel(_ recognizer: UIPanGestureRecognizer) {
            currentConnector?.removeFromSuperview()
            self.origin = nil
            self.destination = nil
            self.currentConnector = nil
            
            self.temporaryReferenceViewXPositionConstraint?.isActive = false
            self.temporaryReferenceViewYPositionConstraint?.isActive = false
            self.temporaryReferenceViewXPositionConstraint = nil
            self.temporaryReferenceViewYPositionConstraint = nil
            self.temporaryReferenceView?.removeFromSuperview()
            self.temporaryReferenceView = nil
        }
        
    }
    
}
