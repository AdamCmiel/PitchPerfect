//
//  PlaybackViewController.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController, AudioPlayerDelegate {
    
    var audioPlayer: AudioPlayer?
    var url: NSURL?
    
    @IBOutlet weak var toggleButton: UIButton!

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
    
    final func playWithMod(mod: AudioPlayer.Modulation) {
        println("playing with mod \(mod.rawValue)")
        
        switch mod {
        case .Chipmunk:
            audioPlayer?.pitch = 1000
            audioPlayer?.rate = 1.0
        case .Vader:
            audioPlayer?.pitch = -1000
            audioPlayer?.rate = 1.0
        case .Snail:
            audioPlayer?.pitch = 1.0
            audioPlayer?.rate = 0.5
        case .Hare:
            audioPlayer?.pitch = 1.0
            audioPlayer?.rate = 2.0
        case .None:
            audioPlayer?.pitch = 1.0
            audioPlayer?.rate = 1.0
        }
        
        audioPlayer?.play()
        changeButton(.Playing)
    }
    
    final func changeButton(status: AudioPlayer.Status) {
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
        case .NoContent:
            fatalError("there's no content")
        }
    }
    
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
