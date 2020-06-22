// 
//  BinaryOutputView.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 15/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import UIKit

public class BinaryOutputView: UIView {
    
    static var questionMarkColor: UIColor { UIColor(hex: 0xC31432) }// { UIColor(hex: 0xFF4F4F) }
    static var underlineColor: UIColor { UIColor(hex: 0xC31432) }// { UIColor(hex: 0xFF4F4F) }
    static var outputLabelColor: UIColor { UIColor(hex: 0x1E1E1E) }
    
    public lazy var questionMark: UILabel = {
        let label = UILabel()
        
        label.font = Font.FrequencyScene.default
        label.text = "?"
        label.numberOfLines = 1
        label.textColor = Self.questionMarkColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public lazy var underline: UIView = {
        let view = UIView()
        
        view.backgroundColor = Self.underlineColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var outputLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.FrequencyScene.monospaced
        label.text = ""
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        label.textColor = Self.outputLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public convenience init() {
        self.init(frame: .zero)
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
        super.didMoveToWindow()
    }
    
    private func setUp() {
        setUpViewHierarchy()
    }
    
    private func setUpViewHierarchy() {
        addSubview(questionMark)
        addSubview(underline)
        addSubview(outputLabel)
    }
    
    public override func layoutSubviews() {
        questionMark.sizeToFit()
        
        super.layoutSubviews()
    }
    
    private func setUpConstraints() {
        questionMark.setContentHuggingPriority(.required, for: .horizontal)
        questionMark.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        questionMark.setContentCompressionResistancePriority(.required, for: .horizontal)
        questionMark.setContentCompressionResistancePriority(.required, for: .vertical)
        
        outputLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        outputLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        outputLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        outputLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            questionMark.topAnchor.constraint(equalTo: topAnchor),
            questionMark.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: questionMark.firstBaselineAnchor, constant: 4),
            underline.centerXAnchor.constraint(equalTo: questionMark.centerXAnchor),
            underline.widthAnchor.constraint(equalTo: questionMark.widthAnchor, constant: 6),
            underline.heightAnchor.constraint(equalToConstant: 2),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            outputLabel.topAnchor.constraint(equalTo: questionMark.topAnchor),
            outputLabel.leadingAnchor.constraint(equalTo: underline.trailingAnchor, constant: 2),
            outputLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            outputLabel.bottomAnchor.constraint(equalTo: questionMark.bottomAnchor)
        ])
    }
    
    private func activateFinalConstraints() {
        removeConstraints(constraints)
        removeConstraints(questionMark.constraints)
        removeConstraints(underline.constraints)
        removeConstraints(outputLabel.constraints)
        
        NSLayoutConstraint.activate([
            outputLabel.topAnchor.constraint(equalTo: topAnchor),
            outputLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: outputLabel.firstBaselineAnchor, constant: 4),
            underline.centerXAnchor.constraint(equalTo: outputLabel.centerXAnchor),
            underline.widthAnchor.constraint(equalTo: outputLabel.widthAnchor, constant: 6),
            underline.heightAnchor.constraint(equalToConstant: 2),
            underline.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func animateFinish() {
        questionMark.removeFromSuperview()
        activateFinalConstraints()
        UIView.animate(withDuration: 0.8, delay: 0, animations: { [weak self] in
            guard let self = self else { return }
            self.questionMark.textColor = .black
            self.underline.backgroundColor = .green
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc
    func animateStoringLastReceivedNumber() {
        let currentText = outputLabel.text ?? ""
        UIView.transition(with: questionMark, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }
            self.questionMark.textColor = Self.questionMarkColor
            self.underline.backgroundColor = Self.underlineColor
            self.outputLabel.text = "\(self.questionMark.text!)\(currentText)"
            self.questionMark.text = "?"
            }, completion: nil)
    }
    var timer: Timer?
    func animateReceivedNumber(_ number: Int) {
        UIView.transition(with: questionMark, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.questionMark.textColor = .systemGreen
            self?.underline.backgroundColor = .systemGreen
            self?.questionMark.text = String(number)
            }, completion: { [weak self] (_) in
                guard let self = self else { return }
                self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.animateStoringLastReceivedNumber), userInfo: nil, repeats: false)
            })
    }
    
    
}
