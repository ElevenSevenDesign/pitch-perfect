//
//  RecordSoundsViewController.swift
//  Sound Recorder
//
//  Created by Nathaniel Coleman on 3/8/15.
//  Copyright (c) 2015 Nathaniel Coleman. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var pauseRecording: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    var audioPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        recordingLabel.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        pauseRecording.hidden = true
    }

    
    @IBAction func recordAudio(sender: UIButton) {
        recordButton.hidden = true
        pauseRecording.hidden = false
        tapToRecordLabel.hidden = true
        stopButton.hidden = false
        recordingLabel.hidden = false
                let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        let currentDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDate) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful.")
            recordButton.enabled = true
            stopButton.hidden = true
            tapToRecordLabel.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio  = data
            
        }
    }
    
    @IBAction func pauseRecordingAudio(sender: UIButton) {
        if audioPaused == false {
          audioRecorder.pause()
          audioPaused = true
          recordingLabel.text = "paused"
            
        } else {
            audioRecorder.record()
            audioPaused = false
            recordingLabel.text = "recording"
        }
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.hidden = true
        pauseRecording.hidden = true
        stopButton.hidden = true
        recordButton.hidden = false
        tapToRecordLabel.hidden = false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
}

