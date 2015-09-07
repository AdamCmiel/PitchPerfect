//
//  AudioRecorder.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/6/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import AVFoundation

struct AudioRecorder {
    var recorder: AVAudioRecorder!
    var url: NSURL!
    
    init() {
        let DOCUMENTS = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let WRITE_PATH = DOCUMENTS.stringByAppendingPathComponent("audioSample.wav")

        var error: NSError?
        
        let url = NSURL(fileURLWithPath: WRITE_PATH)!
        self.url = url
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord,
            error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        }
        
        let settings: [NSObject: AnyObject] = [
            AVNumberOfChannelsKey: 1
        ]
        
        self.recorder = AVAudioRecorder(URL: url, settings: settings, error: &error)
        
        if let err = error {
            println("audioRecorder error: \(err.localizedDescription)")
        }
        
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
    }
    
    func record() {
        recorder.record()
    }
    
    func save() {
        recorder.stop()
    }
}
