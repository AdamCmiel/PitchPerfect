//
//  AudioPlayer.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/6/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate {
    func audioDidFinishPlaying()
}

struct AudioPlayer {
    
    enum Modulation {
        case Chipmunk
        case Vader
        case Snail
        case Hare
    }
    
    enum Status {
        case Playing
        case Paused
        case Stopped
        case NoContent
    }
    
    var url: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var playerNode: AVAudioPlayerNode!
    var pitchNode: AVAudioUnitTimePitch!
    var rateNode: AVAudioUnitVarispeed!
    var delegate: AudioPlayerDelegate?
    
    var pitch: Float {
        get      { return pitchNode.pitch }
        set (_p) { pitchNode.pitch = _p }
    }
    
    var rate: Float {
        get      { return rateNode.rate }
        set (_r) { rateNode.rate = _r }
    }
    
    init(URL _url: NSURL) {
        self.url = _url
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        pitchNode = AVAudioUnitTimePitch()
        rateNode = AVAudioUnitVarispeed()
        
        audioEngine.attachNode(playerNode)
        audioEngine.attachNode(pitchNode)
        audioEngine.attachNode(rateNode)
        
        audioEngine.connect(playerNode, to: pitchNode, format: nil)
        audioEngine.connect(pitchNode, to: rateNode, format: nil)
        audioEngine.connect(rateNode, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)
    }
    
    func prepareToPlay() {
        let audioFile = AVAudioFile(forReading: url.filePathURL, error: nil)
        
        playerNode.scheduleFile(audioFile, atTime: nil) {
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.audioDidFinishPlaying()
            }
        }
    }
    
    func play() {
        prepareToPlay()
        playerNode.play()
    }
    
    func pause() {
        playerNode.pause()
    }
    
    func togglePlaying() -> Status {
        if playerNode.playing {
            pause()
            return .Paused
        }
        else {
            play()
            return .Playing
        }
    }
}
