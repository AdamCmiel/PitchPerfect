//
//  AudioRecorder.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/6/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import AVFoundation

/// Records audio in one channel to be played back with various effects
struct AudioRecorder {
    
    /// :property: recorder
    var recorder: AVAudioRecorder!
    
    /// :property: the url of the audio file to save on disk
    var url: NSURL!
    
    /// - set up the audio session
    /// - open a file at the save location
    /// - prepare to record
    init() {
        let DOCUMENTS = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let WRITE_PATH = DOCUMENTS.stringByAppendingPathComponent("audioSample.wav")

        var error: NSError?
        
        url = NSURL(fileURLWithPath: WRITE_PATH)!
        
        // set up the audio session
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord,
            error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        }
        
        // record in mono to avoid dual playback
        let settings: [NSObject: AnyObject] = [
            AVNumberOfChannelsKey: 1
        ]
        
        recorder = AVAudioRecorder(URL: url, settings: settings, error: &error)
        
        if let err = error {
            println("audioRecorder error: \(err.localizedDescription)")
        }
        
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
    }
    
    /// records audio
    func record() {
        recorder.record()
    }
    
    /// stops recording and the audio file is saved to disk
    func save() {
        recorder.stop()
    }
}
