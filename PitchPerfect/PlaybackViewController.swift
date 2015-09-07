//
//  PlaybackViewController.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import UIKit

/// manage playback interface
class PlaybackViewController: UIViewController, AudioPlayerDelegate {
    
    private var audioPlayer: AudioPlayer?
    
    /// the url of the audioFile to playback
    var url: NSURL?
    
    @IBOutlet weak var toggleButton: UIButton!

    /// play if pause button displayed, pause otherwise
    @IBAction func toggleButtonPressed(sender: AnyObject) {
        let status = audioPlayer!.status
        println("toggle button pressed \(status.rawValue)")
        if status == .Paused {
            // will call changeButton:
            playWithMod(.None)
        }
        else {
            changeButton(status)
        }
    }
    
    @IBAction func hareButtonPressed(sender: AnyObject) {
        playWithMod(.Hare)
    }
    
    @IBAction func snailButtonPressed(sender: AnyObject) {
        playWithMod(.Snail)
    }
    
    @IBAction func chipmunkButtonPressed(sender: AnyObject) {
        playWithMod(.Chipmunk)
    }
    
    @IBAction func vaderButtonPressed(sender: AnyObject) {
        playWithMod(.Vader)
    }
    
    @IBAction func reverbButtonPressed(sender: AnyObject) {
        playWithMod(.Reverb)
    }
    
    @IBAction func distortionButtonPressed(sender: AnyObject) {
        playWithMod(.Distortion)
    }
    
    /// reset levels in the audioPlayer
    /// called by playWithMod
    final private func normalizeLevels() {
        audioPlayer?.pitch = 1.0
        audioPlayer?.rate = 1.0
        audioPlayer?.reverb = 0.0
        audioPlayer?.distortion = 0.0
    }
    
    /// play that modulated effect
    final private func playWithMod(mod: AudioPlayer.Modulation) {
        println("playing with mod \(mod.rawValue)")
        normalizeLevels()
        
        switch mod {
        case .Chipmunk:
            audioPlayer?.pitch = 1000
        case .Vader:
            audioPlayer?.pitch = -1000
        case .Snail:
            audioPlayer?.rate = 0.5
        case .Hare:
            audioPlayer?.rate = 2.0
        case .Reverb:
            audioPlayer?.reverb = 50
        case .Distortion:
            audioPlayer?.distortion = 50
        case .None:
            audioPlayer?.pitch = 1.0
            audioPlayer?.rate = 1.0
        }
        
        audioPlayer?.play()
        changeButton(.Playing)
    }
    
    /// show the play and pause buttons when appropriate
    final private func changeButton(status: AudioPlayer.Status) {
        switch status {
        case .Playing:
            println("changing to pause button")
            toggleButton.setImage(UIImage(named: "pause-blue"), forState: .Normal)
            toggleButton.setImage(UIImage(named: "pause-gray"), forState: .Highlighted)
        case .Stopped:
            println("playback stopped")
            fallthrough
        case .Paused:
            println("changing to play button")
            toggleButton.setImage(UIImage(named: "resume-blue"), forState: .Normal)
            toggleButton.setImage(UIImage(named: "resume-gray"), forState: .Highlighted)
        }
    }
    
    // MARK: - UIViewController
    
    /// create the AudioPlayer with the url from the AudioRecorder
    /// replace back with "Record"
    override func viewWillAppear(animated: Bool) {
        let backButton = UIBarButtonItem()
        backButton.title = "Record"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        audioPlayer = AudioPlayer(URL: url!)
        audioPlayer?.prepareToPlay()
        audioPlayer?.delegate = self
    }
    
    // MARK: - AudioPlayerDelegate
    
    func audioDidFinishPlaying() {
        changeButton(.Stopped)
    }
}
