//
//  MainViewController.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 18.02.2018.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.object(forKey: "totalscore") != nil {
            Model.sharedInstance.totalscore = UserDefaults.standard.object(forKey: "totalscore") as! Int
        }
        
        if Model.sharedInstance.sound == true {
        SKTAudio.sharedInstance().playBackgroundMusic(filename: "Videogame2.wav")
        }
    }
    
    @IBAction func startGame(sender: UIButton) {
        if let storyboard = storyboard {
            let difficultyViewController = storyboard.instantiateViewController(withIdentifier: "DifficultyViewController") as! DifficultyViewController
            navigationController?.pushViewController(difficultyViewController, animated: true)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
