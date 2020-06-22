//
//  FrequencyButton.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 15/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public class FrequencyButton: UIButton {
    
    public var representedBit: Int = 0 {
        didSet {
            waveView.representedBit = representedBit
        }
    }
    
    public lazy var waveView: WaveView = {
        let view = WaveView(bit: representedBit)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var numberLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.FrequencyScene.default
        label.textColor = .black
        label.text = String(representedBit)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public var color: UIColor {
        get { waveView.lineColor }
        set {
            waveView.lineColor = newValue
            numberLabel.textColor = newValue
        }
    }
    
    public init(representedBit: Int) {
        super.init(frame: .zero)
        
        self.representedBit = representedBit
        
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
    }
    
    public override func didMoveToWindow() {
        setUpConstraints()
    }
    
    private func setUp() {
        waveView.lineColor = UIColor(hex: 0x111111)
        numberLabel.textColor = UIColor(hex: 0x111111)
        
        setUpViewHierarchy()
    }
    
    private func setUpViewHierarchy() {
        addSubview(waveView)
        addSubview(numberLabel)
    }
    
    private func setUpConstraints() {
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        
        numberLabel.setContentHuggingPriority(.required, for: .horizontal)
        numberLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        numberLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        numberLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            waveView.topAnchor.constraint(equalTo: topAnchor),
            waveView.centerXAnchor.constraint(equalTo: centerXAnchor),
            waveView.widthAnchor.constraint(equalTo: waveView.heightAnchor),
            waveView.widthAnchor.constraint(equalTo: widthAnchor),
            waveView.heightAnchor.constraint(equalToConstant: 128)
        ])
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: waveView.bottomAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
