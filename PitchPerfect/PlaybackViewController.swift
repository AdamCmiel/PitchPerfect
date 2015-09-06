//
//  PlaybackViewController.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController {
    
    var audioSnippet: Audio?
    
    @IBOutlet weak var toggleButton: UIButton!

    @IBAction func toggleButtonPressed(sender: AnyObject) {
        let status = audioSnippet?.togglePlaying()
        
        if let s = status {
            changeButton(s)
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
    
    final func playWithMod(mod: Audio.Modulation) {
        audioSnippet?.modulateAndPlay(mod)
        changeButton(.Playing)
    }
    
    final func changeButton(status: Audio.Status) {
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
        audioSnippet?.resetPlayer()
        audioSnippet?.finishedPlayingCallback = {
            self.changeButton(.Stopped)
        }
    }

}
