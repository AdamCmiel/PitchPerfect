//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Adam Cmiel on 9/5/15.
//  Copyright (c) 2015 Adam Cmiel. All rights reserved.
//

import UIKit
import AVFoundation

final class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AudioRecorder?
    var recording: Bool {
        get { return !stopButton.hidden }
        set (isRecording) {
            recordingLabel.text = isRecording ? "recording..." : "Tap to record"
            stopButton.hidden = !isRecording
        }
    }

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        println("stop recording audio")
        audioRecorder?.save()
    }

    @IBAction func recordAudio(sender: AnyObject) {
        recording = true
        println("start recording audio")
        
        audioRecorder = AudioRecorder()
        audioRecorder?.recorder.delegate = self
        audioRecorder?.record()
    }
    
    final override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recording = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let playbackViewController = segue.destinationViewController as? PlaybackViewController {
            playbackViewController.url = audioRecorder?.url
        }
    }
    
    final func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        performSegueWithIdentifier("showPlaybackController", sender: self)
    }
    
}
