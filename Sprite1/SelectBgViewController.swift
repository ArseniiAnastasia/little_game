//
//  SelectBgViewController.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 18.02.2018.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import UIKit
import SpriteKit

class SelectBgViewController: UIViewController {
    
    var selectBgDifficulty: DifficultyChoosing!
    
    @IBOutlet weak var totalPoint: UILabel!
    @IBOutlet weak var bg1: UIButton!
    @IBOutlet weak var bg2: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Model.sharedInstance.sound == true {
            SKTAudio.sharedInstance().resumeBackgroundMusic()
        }
        
        totalPoint.text = "\(Model.sharedInstance.totalscore)"
        
        if Model.sharedInstance.totalscore > Model.sharedInstance.level2UnlockValue {
            let image = UIImage(named: "bg02lock.png")
            bg2.setBackgroundImage(image, for: .normal)
        }
    }
    
    @IBAction func selectBG(sender: UIButton) {
        
        if let storyboard = storyboard {
            let gameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            
            gameViewController.gVCBgChoosing = BgCoosing(rawValue: sender.tag)!
            gameViewController.gVCDifficulty = selectBgDifficulty
           
            if gameViewController.gVCBgChoosing.rawValue == 0 {
            navigationController?.pushViewController(gameViewController, animated: true)
            } else if gameViewController.gVCBgChoosing.rawValue == 1 && Model.sharedInstance.totalscore > Model.sharedInstance.level2UnlockValue {
                navigationController?.pushViewController(gameViewController, animated: true)
        }
    }
 }
    
    @IBAction func backButton(sender: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}



