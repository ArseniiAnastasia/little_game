//
//  GameScene_Physics.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 28.01.2018.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import Foundation
import SpriteKit
extension GameScene {
    @objc(didBeginContact:)
    func didBegin(_ contact: SKPhysicsContact) {
        
        let objectNode = contact.bodyA.categoryBitMask == objectGroup ? contact.bodyA.node : contact.bodyB.node
        
        if score > highscore {
            highscore = score
        }
        UserDefaults.standard.set(highscore, forKey: "highScore")
        
        if contact.bodyA.categoryBitMask == objectGroup || contact.bodyB.categoryBitMask == objectGroup {
            hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if shieldBool == false {
               
                hero.physicsBody?.allowsRotation = false
                
                coinObject.removeAllChildren()
                groundObject.removeAllChildren()
                movingObject.removeAllChildren()
                shieldObject.removeAllChildren()
                shieldItemObject.removeAllChildren()
                
                stopGameObject()
                
                timerAddCoin.invalidate()
                timerAddElectricGate.invalidate()
                timerAddMine.invalidate()
                timerAddShieldItem.invalidate()
                
                showHighscore()
                gameover = 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.scene?.isPaused = true
                    self.heroObject.removeAllChildren()
                    self.showHighscoreText()
                    
                    self.gameViewControllerBridge.reloadGameBtn.isHidden = false
                    
                    self.stageLabel.isHidden = true
                    
                    if self.score > self.highscore {
                        self.highscore = self.score
                    }
                    
                    self.highscoreLabel.isHidden = false
                    self.highscoreTextLabel.isHidden = false
                    self.highscoreLabel.text = "\(self.highscore)"
                })
                
            } else {
                objectNode?.removeFromParent()
                shieldObject.removeAllChildren()
                shieldBool = false
                if sound == true { run(shieldOffPreload) }
            }
        }
        
        if contact.bodyA.categoryBitMask == shieldGroup || contact.bodyB.categoryBitMask == shieldGroup {
            let shieldNode = contact.bodyA.categoryBitMask == shieldGroup ? contact.bodyA.node : contact.bodyB.node
            
            if shieldBool == false {
                if sound == true { run(pickCoinPreload) }
                shieldNode?.removeFromParent()
                addShield()
                shieldBool = true
            }
        }
        
     
            if gameover == 0 {
        }
                
        
        if contact.bodyA.categoryBitMask == coinGroup || contact.bodyB.categoryBitMask == coinGroup {
            let coinNode = contact.bodyA.categoryBitMask == coinGroup ? contact.bodyA.node: contact.bodyB.node
            
            if sound == true {
                run(pickCoinPreload)
            }
            
            score = score + 1
            scoreLabel.text = "\(score)"
            
            coinNode?.removeFromParent()
            
        }
    }
    
}

