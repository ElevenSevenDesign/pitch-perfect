//
//  PlaySoundsViewController.swift
//  Sound Recorder
//
//  Created by Nathaniel Coleman on 3/8/15.
//  Copyright (c) 2015 Nathaniel Coleman. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        //This piece of code sets the sound to always play on the Speakers
        let session = AVAudioSession.sharedInstance()
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)
    }
    
    func playAudioWithVariablePitch(pitch : Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var chagePitchEffect = AVAudioUnitTimePitch()
        chagePitchEffect.pitch = pitch
        audioEngine.attachNode(chagePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: chagePitchEffect, format: nil)
        audioEngine.connect(chagePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func stopAudioEngine () {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioClip () {
        stopAudioEngine()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    @IBAction func playSoundSlow(sender: UIButton) {
        audioPlayer.rate = 0.5
        playAudioClip()
    }

    @IBAction func playSoundFast(sender: UIButton) {
        audioPlayer.rate = 1.8
        playAudioClip()
    }
    @IBAction func stopAudio(sender: UIButton) {
       stopAudioEngine()
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-500)
    }
    
    
    
    
}
