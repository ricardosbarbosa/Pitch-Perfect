//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Ricardo Barbosa on 11/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import UIKit
import AVFoundation

extension RecordingViewController : AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      performSegue(withIdentifier: "EffectsViewController", sender: nil)
    }
  }
}
class RecordingViewController: UIViewController{
  
  // MARK: Properties
  
  var audioRecorder: AVAudioRecorder!
  var filePath : URL?
  
  @IBOutlet weak var micButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var label: UILabel!
  
  var recording : Bool = false {
    didSet {
      updateUI()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    micButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    stopButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    updateUI()
  }
  
  func updateUI() {
    micButton.isEnabled = !recording
    stopButton.isEnabled = recording
    label.text = recording ? "Recording in progress" : "Tap to record"
  }
  
  @IBAction func startRecording(_ sender: Any) {
    recording = true
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    filePath = URL(string: pathArray.joined(separator: "/"))
    print(filePath ?? "?")
    
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
    
    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    
  }
  
  @IBAction func stopRecording(_ sender: Any) {
    recording = false
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as! EffectsViewController
    vc.recordedAudioURL = filePath 
  }
  
  
}

