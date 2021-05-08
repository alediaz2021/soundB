//
//  AudioViewController.swift
//  SoundBoard
//
//  Created by Alejandro Diaz Sotolongo on 5/7/21.
//  Copyright © 2021 aaaa. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var addOulet: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playbutton.isEnabled = false
        addOulet.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    
    func setupRecorder(){
        //create audio section
        do{
            let section = AVAudioSession.sharedInstance()
            try section.setCategory(AVAudioSession.Category.playAndRecord)
            try section.overrideOutputAudioPort(.speaker)
            try section.setActive(true)
            //crate URL fpr audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!

                        
            //creating setting for audio recoder
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            //create audio recorder property
            audioRecorder = try  AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.prepareToRecord()

        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func recordAction(_ sender: Any) {
        if audioRecorder!.isRecording{
            //Stop recording
            audioRecorder?.stop()
            //change button title to Record
            recordButton.setTitle("Record", for: .normal)
            
            playbutton.isEnabled = true
            addOulet.isEnabled = true

        } else {
            //Start Recording
            audioRecorder?.record()
            //Change button tittle to Stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func palyAction(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {
            
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = textField.text
        sound.audio = NSData(contentsOf: audioURL!) as! Data
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
}
