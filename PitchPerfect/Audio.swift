//
//  Audio.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import AVFoundation

final class Audio: NSObject, AVAudioRecorderDelegate {
    
    var recorder: AVAudioRecorder
    var player: AVAudioPlayer
    var callback: (() -> ())?
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
            
            var error: NSError?
            self.player = AVAudioPlayer(contentsOfURL: url, error: &error)
            
            if let err = error {
                println("audioPlayer error: \(err.localizedDescription)")
            }
            
            super.init()
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
        callback = then
    }
    
    final func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            callback?()
        }
        else {
            fatalError("did not successfully finish recording")
        }
    }
    
    final func prepareToPlay() {
        var error: NSError?
        player = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        if let err = error {
            println("there was a problem replacing the audio player")
        }
        
        player.prepareToPlay()
    }
    
    final func play() {
        println("play that back")
        player.play()
    }
    
}
