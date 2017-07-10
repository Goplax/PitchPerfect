//
//  RecordsSoundViewController.swift
//  PitchPerfect
//
//  Created by Gopal Chandra Nepal on 08/07/2017.
//  Copyright © 2017 Gopal Chandra Nepal. All rights reserved.
//

import UIKit
import AVFoundation

class RecordsSoundViewController: UIViewController, AVAudioRecorderDelegate {
	
	var audioRecorder: AVAudioRecorder!

	@IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopRecordingButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		stopRecordingButton.isEnabled = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}

	@IBAction func recordAudio(_ sender: Any) {
		// Action when record button is pressed
		recordingLabel.text = "Recording in Progress"
		stopRecordingButton.isEnabled = true
		recordButton.isEnabled = false
		
		let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
		
		let settings = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		]
		
		do {
			audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
			audioRecorder.delegate = self
			audioRecorder.record()
			
		} catch {
		}
	
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}

	@IBAction func stopRecording(_ sender: Any) {
		recordButton.isEnabled = true
		stopRecordingButton.isEnabled = false
		recordingLabel.text = "Tap to Record"
		
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
		
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		if flag {
			performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
		}
		else {
			print("recording failed")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "stopRecording" {
			let playSoundsVC = segue.destination as! PlaySoundViewController
			let recordedAudioURL = sender as! URL
			playSoundsVC.recordedAudioURL = recordedAudioURL
			
		}
	}

}

