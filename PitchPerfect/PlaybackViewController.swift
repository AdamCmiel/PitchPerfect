//
//  PlaybackViewController.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController, AudioPlayerDelegate {
    
    var audioSnippet: AudioPlayer?
    var url: NSURL?
    
    @IBOutlet weak var toggleButton: UIButton!

    @IBAction func toggleButtonPressed(sender: AnyObject) {
        let status = audioSnippet?.togglePlaying()
        
        if let s = status {
            self.changeButton(s)
        }
        else {
            fatalError("there isn't a snippet")
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
        //audioSnippet?.modulateAndPlay(mod)
        switch mod {
        case .Chipmunk:
            audioSnippet?.pitch = 1000
        case .Vader:
            audioSnippet?.pitch = -1000
        case .Snail:
            audioSnippet?.rate = 0.5
        case .Hare:
            audioSnippet?.rate = 2.0
        }
        audioSnippet?.prepareToPlay()
        audioSnippet?.play()
        changeButton(.Playing)
    }
    
    final func changeButton(status: AudioPlayer.Status) {
        switch status {
        case .Playing:
            toggleButton.setImage(UIImage(named: "pause-blue"), forState: .Normal)
            toggleButton.setImage(UIImage(named: "pause-gray"), forState: .Highlighted)
        case .Stopped:
            fallthrough
        case .Paused:
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
        
        audioSnippet = AudioPlayer(URL: url!)
        audioSnippet?.prepareToPlay()
        audioSnippet?.delegate = self
    }
    
    func audioDidFinishPlaying() {
        audioSnippet?.cleanup()
        audioSnippet = nil
        self.changeButton(.Stopped)
    }
}
