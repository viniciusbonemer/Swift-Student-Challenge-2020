//
//  ConnectorView.swift
//  FirstScene
//
//  Created by Vinícius Bonemer on 11/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public class ConnectorView: UIView {
    
    public var leadingEndPointColor: UIColor {
        get { leadingEndPoint.color }
        set { leadingEndPoint.color = newValue }
    }
    
    public var trailingEndPointColor: UIColor {
        get { trailingEndPoint.color }
        set { trailingEndPoint.color = newValue }
    }
    
    public var leadingEndPointHighlightColor: UIColor {
        get { leadingEndPoint.highlightColor }
        set { leadingEndPoint.highlightColor = newValue }
    }
    
    public var trailingEndPointHighlightColor: UIColor {
        get { trailingEndPoint.highlightColor }
        set { trailingEndPoint.highlightColor = newValue }
    }
    
    public var showsLeadingEndPoint: Bool = true {
        willSet {
            if newValue {
                leadingEndPoint.isHidden = false
            } else {
                leadingEndPoint.isHidden = true
            }
        }
    }
    
    public var showsTrailingEndPoint: Bool = true {
        willSet {
            if newValue {
                trailingEndPoint.isHidden = false
            } else {
                trailingEndPoint.isHidden = true
            }
        }
    }
    
    public var leadingEndPointAnchor: NSLayoutXAxisAnchor {
        leadingEndPoint.centerXAnchor
    }
    
    public var trailingEndPointAnchor: NSLayoutXAxisAnchor {
        trailingEndPoint.centerXAnchor
    }
    
    public var canTilt: Bool = false {
        didSet {
            if canTilt {
                cableView.curveType = .straight
            }
            updateRelaxableConstraints()
        }
    }
    
    internal lazy var leadingEndPoint: EndPointView = {
        let view = EndPointView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    internal lazy var cableView: CableView = {
        let view = CableView()
        
        view.leadingAnchorPoint = leadingEndPoint
        view.trailingAnchorPoint = trailingEndPoint
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    internal lazy var trailingEndPoint: EndPointView = {
        let view = EndPointView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    fileprivate var shouldStopRinging = false
    
    public fileprivate(set) var isRinging = false
    
    // MARK: - Initialization
    
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
    
    private func setUp() {
        setUpViewHierarchy()
    }
    
    private func setUpViewHierarchy() {
        addSubview(cableView)
        addSubview(leadingEndPoint)
        addSubview(trailingEndPoint)
    }
    
    /// Set those when inclining
    private lazy var notTiltingConstraints: [NSLayoutConstraint] = [
        leadingEndPoint.centerYAnchor.constraint(equalTo: cableView.centerYAnchor),
        trailingEndPoint.centerYAnchor.constraint(equalTo: cableView.centerYAnchor),
        
        leadingEndPoint.leadingAnchor.constraint(equalTo: leadingAnchor),
        trailingEndPoint.trailingAnchor.constraint(equalTo: trailingAnchor),
        
        cableView.leadingAnchor.constraint(equalTo: leadingEndPoint.centerXAnchor),
        cableView.trailingAnchor.constraint(equalTo: trailingEndPoint.centerXAnchor)
    ]
    
    private lazy var tiltingConstraints: [NSLayoutConstraint] = [
        leadingEndPoint.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
        trailingEndPoint.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
        trailingEndPoint.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
        leadingEndPoint.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
    ]
    
    private func updateRelaxableConstraints() {
        guard let _ = window else { return }
        
        // Deactivate
        NSLayoutConstraint.deactivate( canTilt ? notTiltingConstraints : tiltingConstraints )
        // Activate
        NSLayoutConstraint.activate( canTilt ? tiltingConstraints : notTiltingConstraints )
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            leadingEndPoint.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            leadingEndPoint.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            trailingEndPoint.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            trailingEndPoint.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        if canTilt {
            NSLayoutConstraint.activate(tiltingConstraints)
        } else {
            NSLayoutConstraint.activate(notTiltingConstraints)
        }
            
        NSLayoutConstraint.activate([
            cableView.heightAnchor.constraint(equalTo: heightAnchor),
            cableView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cableView.widthAnchor.constraint(equalTo: widthAnchor, constant: -EndPointView.Highlighter.defaultSize.width)
        ])
    }
}

extension ConnectorView {
    
    public func startRinging() {
        guard !isRinging else { return }
        guard !shouldStopRinging else {
            shouldStopRinging = false
            return
        }
        
        isRinging = true
        cableView.vibrate()
        
        let restart: (Bool) -> Void = { [weak self] _ in
            self?.isRinging = false
            self?.startRinging()
        }
        
        if showsLeadingEndPoint {
            let removeHighlight: (Bool) -> Void = { [weak self] _ in
                self?.leadingEndPoint.removeHighlight(animated: true, completion: restart)
            }
            leadingEndPoint.showHighlight(animated: true, completion: removeHighlight)
        }
        if showsTrailingEndPoint {
            let removeHighlight: (Bool) -> Void = { [weak self] _ in
                self?.trailingEndPoint.removeHighlight(animated: true, completion: restart)
            }
            trailingEndPoint.showHighlight(animated: true, completion: removeHighlight)
        }
    }
    
    public func stopRinging() {
        guard isRinging else { return }
        
        shouldStopRinging = true
    }
    
}
