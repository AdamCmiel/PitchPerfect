//
//  Audio.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import AVFoundation

final class Audio: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var recorder: AVAudioRecorder
    var player: AVAudioPlayer?
    var finishedRecordingCallback: (() -> ())?
    var finishedPlayingCallback: (() -> ())?
    var url: NSURL
    
    override init () {
        let DOCUMENTS = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let WRITE_PATH = DOCUMENTS.stringByAppendingPathComponent("audioSample.caf")

        let recordSettings: [NSObject: AnyObject] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Medium.rawValue,
            AVEncoderBitRateKey : 16,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey : 44100.0
        ]
        
        var error: NSError?
        
        
        if let url = NSURL(fileURLWithPath: WRITE_PATH) {
            self.url = url
            
            let audioSession = AVAudioSession.sharedInstance()
            audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord,
                error: &error)
            
            if let err = error {
                println("audioSession error: \(err.localizedDescription)")
            }
            
            self.recorder = AVAudioRecorder(URL: url, settings: recordSettings, error: &error)
            
            if let err = error {
                println("audioRecorder error: \(err.localizedDescription)")
            }
            
            super.init()
            resetPlayer()
        }
        else {
            fatalError("Cannot record audio")
        }
        
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
    }
    
    final func record() {
        recorder.record()
    }
    
    final func save(then: () -> ()) {
        recorder.stop()
        finishedRecordingCallback = then
    }
    
    final func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            finishedRecordingCallback?()
        }
        else {
            fatalError("did not successfully finish recording")
        }
    }
    
    final func resetPlayer() {
        var error: NSError?
        player = AVAudioPlayer(contentsOfURL: url, error: &error)
        player?.delegate = self
        
        if let err = error {
            println("audioPlayer error: \(err.localizedDescription)")
        }
        
        player?.prepareToPlay()
    }
    
    final func modulateAndPlay(mod: Modulation) {
        switch mod {
        case .Chipmunk:
            player?.rate = 2.0
        case .Vader:
            player?.rate = 0.5
        case .Snail:
            player?.rate = 0.5
        case .Hare:
            player?.rate = 2.0
        }
        
        player?.play()
    }
    
    enum Modulation {
        case Chipmunk
        case Vader
        case Snail
        case Hare
    }
    
    final func togglePlaying() -> Status {
        if let p = player {
            if p.playing {
                p.pause()
            }
            else {
                p.play()
            }
            
            return p.playing ? .Playing : .Paused
        }
        else {
            return .NoContent
        }
    }
    
    enum Status {
        case Playing
        case Paused
        case Stopped
        case NoContent
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        finishedPlayingCallback?()
    }
    
}
