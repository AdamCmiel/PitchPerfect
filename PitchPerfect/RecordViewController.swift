//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import UIKit
import AVFoundation

/// Initial view controller.  Manage AudioRecorder interface
final class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    private var audioRecorder: AudioRecorder?
    
    /// reset UI on recording state
    private var recording: Bool {
        get { return !stopButton.hidden }
        set (isRecording) {
            recordingLabel.text = isRecording ? "recording..." : "Tap to record"
            stopButton.hidden = !isRecording
        }
    }

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    /// stop recording
    @IBAction func stopButtonPressed(sender: AnyObject) {
        println("stop recording audio")
        audioRecorder?.save()
    }

    /// start recording
    @IBAction func recordAudio(sender: AnyObject) {
        recording = true
        println("start recording audio")
        
        audioRecorder = AudioRecorder()
        audioRecorder?.recorder.delegate = self
        audioRecorder?.record()
    }
    
    // MARK: - UIViewController
    
    /// set the UI to the not recording state
    final override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recording = false
    }
    
    /// set the url of the AudioPlayer set from the AudioRecorder
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let playbackViewController = segue.destinationViewController as? PlaybackViewController {
            playbackViewController.url = audioRecorder?.url
        }
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    /// segue to the PlaybackController on finish recording
    final func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        performSegueWithIdentifier("showPlaybackController", sender: self)
    }
    
}
