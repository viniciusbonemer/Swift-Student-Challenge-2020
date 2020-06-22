// 
//  FrequencyView.swift
//  FourthScene
//
//  Created by Vinícius Bonemer on 15/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import Combine
import UIKit
import PlaygroundSupport

public class FrequencyView: GradientView {
    
    public lazy var oscilloscopeView: OscilloscopeView = {
        let view = OscilloscopeView()
        
        view.backgroundColor = UIColor(hex: 0xCFD5F9)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var outputView: BinaryOutputView = {
        let view = BinaryOutputView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var zeroButton: FrequencyButton = {
        let button = FrequencyButton(representedBit: 0)
        
        button.addTarget(self, action: #selector(zeroButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    public lazy var oneButton: FrequencyButton = {
        let button = FrequencyButton(representedBit: 1)
        
        button.addTarget(self, action: #selector(oneButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    public lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [zeroButton, oneButton])
        
        stack.axis = .horizontal
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
//    var colors: AnyPublisher<UIColor, Never>!
    
    var cancellables: Set<AnyCancellable> = []
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
    }
    
    public override func didMoveToWindow() {
        setUpConstraints()
    }
    
    private func setUp() {
        cornerRadius = 0
        backgroundColor = .white
        topColor = UIColor(hex: 0x5B247A)
        bottomColor = UIColor(hex: 0x6078EA)
        gradientLayer.opacity = 0.6
        
        setUpViewHierarchy()
        isUserInteractionEnabled = true
        
        WaveScene.animationHappening
            .throttle(for: .milliseconds(500), scheduler: RunLoop.main, latest: false)
            .subscribe(on: RunLoop.main)
            .map(!)
            .sink(receiveCompletion: { [weak self] (completion) in
                guard case .finished = completion else { return }
                self?.waveFinished()
            },
                  receiveValue: { [weak self] in self?.setButtonsEnabled($0) })
            .store(in: &cancellables)
    }
    
    private func setButtonsEnabled(_ isEnabled: Bool) {
        if isEnabled {
            enableButton(zeroButton)
            enableButton(oneButton)
        } else {
            disableButton(zeroButton)
            disableButton(oneButton)
        }
    }
    
    private func waveFinished() {
        outputView.animateFinish()
        let message = "### You got it! \nYou decoded one byte!"
        let link = "\n\n[**Next page**](@next)"
        PlaygroundPage.current.assessmentStatus = .pass(message: "\(message)\(link)")
    }
    
    private func enableButton(_ button: FrequencyButton) {
//        button.color = UIColor(hex: 0x111111)
        button.waveView.shapeLayer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        button.waveView.shapeLayer.strokeColor = UIColor(hex: 0x111111).cgColor
        button.numberLabel.textColor = UIColor(hex: 0x111111)
        button.isEnabled = true
    }
    
    private func disableButton(_ button: FrequencyButton) {
        button.color = .gray
        button.isEnabled = false
    }
    
    private func setUpViewHierarchy() {
        addSubview(oscilloscopeView)
        addSubview(outputView)
        addSubview(buttonStack)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            oscilloscopeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                  constant: 70),
            oscilloscopeView.widthAnchor.constraint(equalTo: widthAnchor),
            oscilloscopeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            oscilloscopeView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor,
                                                     multiplier: 1.0/3.0)
        ])
        
        NSLayoutConstraint.activate([
            outputView.topAnchor.constraint(equalTo: oscilloscopeView.bottomAnchor, constant: 45),
            outputView.centerXAnchor.constraint(equalTo: centerXAnchor),
            outputView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -68),
            buttonStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        ])
        
        oneButton.widthAnchor.constraint(equalTo: zeroButton.widthAnchor).isActive = true
//        oneButton.heightAnchor.constraint(equalTo: zeroButton.widthAnchor).isActive = true
        oneButton.widthAnchor.constraint(equalTo: oscilloscopeView.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    @objc
    private func zeroButtonPressed(_ sender: FrequencyButton) {
        receivedNumber(0)
    }
    
    @objc
    private func oneButtonPressed(_ sender: FrequencyButton) {
        receivedNumber(1)
    }
    
    private func receivedNumber(_ number: Int) {
        setNeedsDisplay()
        let success = oscilloscopeView.waveScene.receive(bit: number)
        guard success else {
            Player.current.playFailureSound()
            return
        }
        Player.current.playSuccessSound()
        disableButton(zeroButton)
        disableButton(oneButton)
        outputView.animateReceivedNumber(number)
    }
    
//    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        var currentText = outputView.outputLabel.text ?? ""
//        if currentText.count == 4 { currentText.insert(" ", at: currentText.startIndex) }
//        let newValue = Int(round(Double.random(in: 0...1)))
//        outputView.outputLabel.text = "\(newValue)\(currentText)"
//        outputView.setNeedsDisplay()
//    }
    
}
