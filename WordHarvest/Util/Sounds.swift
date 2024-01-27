//
//  Sounds.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/23/24.
//

import SwiftUI
import AVFoundation




class Sounds {
    static var audioPlayer: AVPlayer?
    static func playSounds(soundFileURL: URL?) {
        guard let soundFileURL = soundFileURL else { return }
        
        audioPlayer =  AVPlayer(url: soundFileURL )
        audioPlayer?.play()
    }
}
