
//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import UIKit

final class RecordViewController: UIViewController {
    
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
        performSegueWithIdentifier("showPlaybackController", sender: self)
    }

    @IBAction func recordAudio(sender: AnyObject) {
        hidden = false
    }
    
    final override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hidden = true
    }
}

