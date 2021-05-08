//
//  ViewController.swift
//  SoundBoard
//
//  Created by Alejandro Diaz Sotolongo on 5/7/21.
//  Copyright © 2021 aaaa. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    var sound : [Sound] = []
    var audioPlayer : AVAudioPlayer?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            sound = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        } catch {}
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sound.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let soundd = sound[indexPath.row]
        cell.textLabel?.text = soundd.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soundd = sound[indexPath.row]
        do {
        audioPlayer = try AVAudioPlayer(data: soundd.audio!)
            audioPlayer?.play()
        } catch {}
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let soundd = sound[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(soundd)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                sound = try context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            } catch {}

            
        }
    }

}

