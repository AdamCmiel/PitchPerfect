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
    
    var status: Status {
        get {
            if playerNode.playing {
                return .Playing
            }
            else {
                return .Paused
            }
        }
    }
    
    enum Modulation: String {
        case Chipmunk = "Chipmunk"
        case Vader = "Vader"
        case Snail = "Snail"
        case Hare = "Hare"
        case Reverb = "Reverb"
        case Distortion = "Distortion"
        case None = "None"
    }
    
    enum Status: String {
        case Playing = "playing"
        case Paused = "paused"
        case Stopped = "stopped"
        case NoContent = "noContent"
    }
    
    var url: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var playerNode: AVAudioPlayerNode!
    var pitchNode: AVAudioUnitTimePitch!
    var rateNode: AVAudioUnitVarispeed!
    var reverbNode: AVAudioUnitReverb!
    var distortionNode: AVAudioUnitDistortion!
    var delegate: AudioPlayerDelegate!
    
    var pitch: Float {
        get      { return pitchNode.pitch }
        set (_p) { pitchNode.pitch = _p }
    }
    
    var rate: Float {
        get      { return rateNode.rate }
        set (_r) { rateNode.rate = _r }
    }
    
    // MARK: Extra Credit
    
    var reverb: Float {
        get      { return reverbNode.wetDryMix }
        set (_r) { reverbNode.wetDryMix = _r }
    }
    
    var distortion: Float {
        get      { return distortionNode.wetDryMix }
        set (_r) { distortionNode.wetDryMix = _r }
    }
    
    init(URL _url: NSURL) {
        self.url = _url
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        pitchNode = AVAudioUnitTimePitch()
        rateNode = AVAudioUnitVarispeed()
        reverbNode = AVAudioUnitReverb()
        distortionNode = AVAudioUnitDistortion()
        
        [playerNode, pitchNode, rateNode, reverbNode, distortionNode].map {
            self.audioEngine.attachNode($0)
        }
        
        audioEngine.connect(playerNode, to: pitchNode, format: nil)
        audioEngine.connect(pitchNode, to: rateNode, format: nil)
        audioEngine.connect(rateNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: distortionNode, format: nil)
        audioEngine.connect(distortionNode, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)
    }
    
    func prepareToPlay() {
        let audioFile = AVAudioFile(forReading: url.filePathURL, error: nil)
        
        playerNode.scheduleFile(audioFile, atTime: nil) {
            dispatch_async(dispatch_get_main_queue()) {
                self.playerNode.pause()
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
}
