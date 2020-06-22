//
//  PackageTracker.swift
//  SecondScene
//
//  Created by Vinícius Bonemer on 14/05/20.
//  Copyright © 2020 ViniciusBonemer. All rights reserved.
//

import SpriteKit

public final class PackageTracker {
    
    private static var treadmillCount: Int { 3 }
    
    private static var minSameColorBoxCount: Int { 3 }
    
    private static var maxSameColorBoxCount: Int { 4 }
    
    public var colors: [Color] = Array(Color.allCases
        .filter({ ![.gray, .red, .green].contains($0) })
        .shuffled().prefix(PackageTracker.treadmillCount))
    
    public var isFinished: Bool { boxSequence.isEmpty }
    
    private lazy var expectedPackageCount: [Int] = {
        let minCount = PackageTracker.minSameColorBoxCount
        let maxCount = PackageTracker.maxSameColorBoxCount
        return colors.map { _ in .random(in: minCount...maxCount) }
    }()
    
    private var treadmillUseCount = [Int](repeating: 0, count: treadmillCount)
    
    private var deliveredPackages = [Int](repeating: 0, count: treadmillCount)
    
    private lazy var boxSequence: [Box] = {
        var boxColors = [Color]()
        for (index, count) in expectedPackageCount.enumerated() {
            boxColors.append(contentsOf: Array(repeating: colors[index],
                                            count: count))
        }
        return boxColors.shuffled().map { BoxFactory.createBox(color: $0) }
    }()
    
    private var nextTimerDuration: TimeInterval {
        
        defer {
            packageInterval *= 0.9
        }
        
        return packageInterval
    }
    
    private var packageInterval: TimeInterval = 1.5
    
    weak var scene: TreadmillScene?
    
    private var timer: Timer?
    
    // Treadmills
    
    public lazy var topLeftTreadmill: Treadmill = TreadmillFactory.createTopLeftTreadmillNode()
    
    public lazy var middleLeftTreadmill: Treadmill = TreadmillFactory.createMiddleLeftTreadmillNode()
    
    public lazy var bottomLeftTreadmill: Treadmill = TreadmillFactory.createBottomLeftTreadmillNode()
    
    public lazy var topRightTreadmill: Treadmill = {
        let color = colors[0]
        return TreadmillFactory.createTopRightTreadmillNode(color: color)
    }()
    
    public lazy var middleRightTreadmill: Treadmill = {
        let color = colors[1]
        return TreadmillFactory.createMiddleRightTreadmillNode(color: color)
    }()
    
    public lazy var bottomRightTreadmill: Treadmill = {
        let color = colors[2]
        return TreadmillFactory.createBottomRightTreadmillNode(color: color)
    }()
    
    // MARK: Methods
    
    public func start(on scene: TreadmillScene) {
        self.scene = scene
        
        setUpTimer()
    }
    
    public func expectedPackgeCount(for treadmill: Treadmill) -> Int {
        guard treadmill.side == .right else { return 0 }
        let colorIndex = colors.firstIndex(of: treadmill.customColor)!
        return expectedPackageCount[colorIndex]
    }
    
    private func setUpTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: nextTimerDuration,
                                          target: self,
                                          selector: #selector(sendNextBox),
                                          userInfo: nil,
                                          repeats: false)
    }
    
    @objc
    private func sendNextBox() {
        self.timer = nil
        
        guard !boxSequence.isEmpty else { return }
        
        let nextBox = boxSequence.popLast()!
        let nextTreadmill = getNextTreadmill()
        nextBox.position = nextTreadmill.position
        nextBox.position.x -= nextBox.size.width
        
        let vec = CGPoint(x: nextBox.size.width/2, y: nextBox.size.height/2)
        let theta = CGFloat.pi/8
        let y = sin(theta) * vec.x + cos(theta) * vec.y
        let deltaY = nextTreadmill.size.height / 2 - y
        nextBox.position.y += CGFloat.random(in: -deltaY ... deltaY)
        nextBox.zRotation = CGFloat.random(in: -theta ... theta)
        
        let colorIndex = colors.firstIndex(of: nextBox.customColor)!
        deliveredPackages[colorIndex] += 1
        
        scene?.addBox(nextBox)
        scene?.didPlaceBox(nextBox, on: nextTreadmill)
        
        setUpTimer()
    }
    
    private func getNextTreadmill() -> Treadmill {
        let indexes = Array(0..<colors.count)
        let availableIndexes = indexes.filter({
            treadmillUseCount[$0] != PackageTracker.maxSameColorBoxCount
        })
        let index = availableIndexes.randomElement()!
        treadmillUseCount[index] += 1
        
        switch index {
        case 0:
            return topLeftTreadmill
        case 1:
            return middleLeftTreadmill
        case 2:
            return bottomLeftTreadmill
        default:
            fatalError()
        }
    }
    
    private func index(of color: Color) -> Int {
        return colors.firstIndex(of: color)!
    }
    
}
