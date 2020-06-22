//
//  Ressources.swift
//  BookCore
//
//  Created by Vinícius Bonemer on 13/05/20.
//

import Foundation

public enum Ressources {
    
    private static var ringToneFileName: String { "RingTone" }
    private static var ringToneFileExtension: String { "m4a" }
    
    public static var ringToneURL: URL {
        Bundle.main.url(
            forResource: Ressources.ringToneFileName,
            withExtension: Ressources.ringToneFileExtension)!
    }
    
    public static var successSoundFileName: String { "success" }
    private static var successSoundFileExtension: String { "wav" }
    
    public static var successSoundURL: URL {
        Bundle.main.url(
            forResource: Ressources.successSoundFileName,
            withExtension: Ressources.successSoundFileExtension)!
    }
    
    public static var failureSoundFileName: String { "failure" }
    private static var failureSoundFileExtension: String { "wav" }
    
    public static var failureSoundURL: URL {
        Bundle.main.url(
            forResource: Ressources.failureSoundFileName,
            withExtension: Ressources.failureSoundFileExtension)!
    }
    
    public static var backgroundMusicFileName: String { "LowTownBlues" }
    private static var backgroundMusicFileExtension: String { "mov" }
    
    public static var backgroundMusicURL: URL {
        Bundle.main.url(
            forResource: Ressources.backgroundMusicFileName,
            withExtension: Ressources.backgroundMusicFileExtension)!
    }
    
}
