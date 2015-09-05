//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import UIKit

final class RecordViewController: UIViewController {
    
    /**
        :property: audioSnippet
        :property: hidden
     */
    var audioSnippet: Audio?
    var hidden: Bool {
        get {
            return self.recordingLabel.hidden && self.stopButton.hidden
        }
        set (isHidden) {
            self.recordingLabel.hidden = isHidden
            self.stopButton.hidden = isHidden
        }
    }

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        println("stop recording audio")
        audioSnippet?.save {
            self.performSegueWithIdentifier("showPlaybackController", sender: self)
        }
    }

    @IBAction func recordAudio(sender: AnyObject) {
        hidden = false
        println("start recording audio")
        
        audioSnippet = Audio()
        audioSnippet?.record()
    }
    
    final override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let playbackViewController = segue.destinationViewController as? PlaybackViewController {
            playbackViewController.audioSnippet = audioSnippet
        }
    }
}

