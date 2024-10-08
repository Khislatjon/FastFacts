//
//  AudioPlayerProtocol.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import AVFoundation

protocol AudioPlayerProtocol {
    var recordedAudio: URL? { get set }
    var showAudioPlayerWave: Bool { get set }
    func createAudioPlayer()
}

class RecorderDelegate: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var parent: AudioPlayerProtocol
    
    init(parent: AudioPlayerProtocol) {
        self.parent = parent
    }
    
    // AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.parent.recordedAudio = recorder.url
            self.parent.createAudioPlayer()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: (any Error)?) {
        if let error = error {
            print("Recording error: \(error.localizedDescription)")
        }
    }
    
    //AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.parent.showAudioPlayerWave = false
        }
    }
}

