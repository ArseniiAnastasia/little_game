//
//  GameScene.Touch.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 21.01.18.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameover == 0 {
            if tabToPlayLabel.isHidden == false {
                tabToPlayLabel.isHidden = true
            }
            
            if gameover == 0 {
        hero.physicsBody?.velocity = CGVector.zero
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 180))
            }
        }
    
    }
}
