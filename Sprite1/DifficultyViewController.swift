//
//  DifficultyViewController.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 18.02.2018.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import UIKit
import SpriteKit

class DifficultyViewController: UIViewController {
    
    @IBAction func selectDifficulty(sender: UIButton) {
        
        if let storyboard = storyboard {
            let selectBgViewController = storyboard.instantiateViewController(withIdentifier: "SelectBgViewController") as! SelectBgViewController
            
            selectBgViewController.selectBgDifficulty = DifficultyChoosing(rawValue: sender.tag)!
            
            navigationController?.pushViewController(selectBgViewController, animated: true)
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
}
