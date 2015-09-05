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

    @IBAction func playButtonPressed(sender: AnyObject) {
        audioSnippet?.play()
    }
    
    override func viewWillAppear(animated: Bool) {
        let backButton = UIBarButtonItem()
        backButton.title = "Record"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        audioSnippet?.prepareToPlay()
    }

}
