//
//  AudioPlayer.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/6/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate {
    /// inspired by AVAudioPlayerDelegate
    func audioDidFinishPlaying()
}

/// plays audio recorded by an AudioRecorder
struct AudioPlayer {
    
    /// returns the playerNode's playing status
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
    
    /// A modulation to affect audio playback
    ///
    /// - Chipmunk: high pitch
    /// - Vader: low pitch
    /// - Snail: slow playback
    /// - Hare: quick playback
    /// - Reverb: silky reverb
    /// - Distortion: adds noise
    /// - None: clear playback
    enum Modulation: String {
        case Chipmunk = "Chipmunk"
        case Vader = "Vader"
        case Snail = "Snail"
        case Hare = "Hare"
        case Reverb = "Reverb"
        case Distortion = "Distortion"
        case None = "None"
    }
    
    /// Playback status
    ///
    /// - Playing: now playing sound
    /// - Paused: not playing, can resume
    /// - Stopped: not playing, will start at beginning
    enum Status: String {
        case Playing = "playing"
        case Paused = "paused"
        case Stopped = "stopped"
    }
    
    /// the audio file url
    var url: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    
    /// The audio effect nodes
    var playerNode: AVAudioPlayerNode!
    var pitchNode: AVAudioUnitTimePitch!
    var rateNode: AVAudioUnitVarispeed!
    var reverbNode: AVAudioUnitReverb!
    var distortionNode: AVAudioUnitDistortion!
    
    var delegate: AudioPlayerDelegate!
    
    /// Set the pitch of the pitchNode
    var pitch: Float {
        get      { return pitchNode.pitch }
        set (_p) { pitchNode.pitch = _p }
    }
    
    /// Set the playback rate of the Varispeed node
    var rate: Float {
        get      { return rateNode.rate }
        set (_r) { rateNode.rate = _r }
    }
    
    // MARK: Extra Credit
    
    /// Set the wetDryMix rate of the reverb Node.  Varies between 0 (default) and 100
    var reverb: Float {
        get      { return reverbNode.wetDryMix }
        set (_r) { reverbNode.wetDryMix = _r }
    }
    
    /// Set the wetDryMix rate of the distortion Node.  Varies between 0 (default) and 100
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
        
        // attach nodes to the engine
        [playerNode, pitchNode, rateNode, reverbNode, distortionNode].map {
            self.audioEngine.attachNode($0)
        }
        
        // link up nodes. A different order could produce different output
        audioEngine.connect(playerNode, to: pitchNode, format: nil)
        audioEngine.connect(pitchNode, to: rateNode, format: nil)
        audioEngine.connect(rateNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: distortionNode, format: nil)
        audioEngine.connect(distortionNode, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)
    }
    
    /// Open the audio file for reading and schedules the playback at the beginning of the file
    /// Call the delegate audioDidFinishPlaying method
    func prepareToPlay() {
        let audioFile = AVAudioFile(forReading: url.filePathURL, error: nil)
        
        playerNode.scheduleFile(audioFile, atTime: nil) {
            dispatch_async(dispatch_get_main_queue()) {
                self.playerNode.pause()
                self.delegate?.audioDidFinishPlaying()
            }
        }
    }
    
    /// play back audio
    func play() {
        
        // stopgap for playback bug, instead of re-hooking up audio graph
        prepareToPlay()
        playerNode.play()
    }
    
    /// Pause playback
    func pause() {
        playerNode.pause()
    }
}
