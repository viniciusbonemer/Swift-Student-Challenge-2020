//
//  PlaygroundPersistent.swift
//  BookCore
//
//  Created by Vinícius Bonemer on 11/05/20.
//

import PlaygroundSupport

@propertyWrapper
struct PlaygroundPersistent {
    let key: String
    let defaultValue: PlaygroundValue
    
    init(_ key: String, defaultValue: PlaygroundValue) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: PlaygroundValue {
        get {
            return PlaygroundKeyValueStore.current[key] ?? defaultValue
        }
        set {
            PlaygroundKeyValueStore.current[key] = newValue
        }
    }
}

//class A {
//    
//    var skills: [Double] {
//        get {
//            guard case .array(let persistedSkills) = transferSkills else { return .init(repeating: 0, count: 9) }
//            return persistedSkills.map {
//                guard case .floatingPoint(let value) = $0 else { fatalError() }
//                return value
//            }
//        }
//        set {
//            transferSkills = .array(newValue.map { .floatingPoint($0) })
//        }
//    }
//    
//    @PlaygroundPersistent("skills", defaultValue: .array(Array(repeating: 0.0, count: 9).map { .floatingPoint($0) }))
//    var transferSkills: PlaygroundValue
//    
//}
