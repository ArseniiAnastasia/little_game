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
        
        if Model.sharedInstance.score > Model.sharedInstance.highscore {
            Model.sharedInstance.highscore = Model.sharedInstance.score
        }
        UserDefaults.standard.set(Model.sharedInstance.highscore, forKey: "highScore")
        
        if contact.bodyA.categoryBitMask == objectGroup || contact.bodyB.categoryBitMask == objectGroup {
            hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if shieldBool == false {
                
                 Model.sharedInstance.totalscore = Model.sharedInstance.totalscore + Model.sharedInstance.score
               
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
                    self.gameViewControllerBridge.returnMainBtn.isHidden = false 
                    
                    self.stageLabel.isHidden = true
                    
                    if Model.sharedInstance.self.score > Model.sharedInstance.self.highscore {
                        Model.sharedInstance.self.highscore = Model.sharedInstance.self.score
                    }
                    
                    self.highscoreLabel.isHidden = false
                    self.highscoreTextLabel.isHidden = false
                    self.highscoreLabel.text = "\(Model.sharedInstance.self.highscore)"
                })
                
                SKTAudio.sharedInstance().pauseBackgroundMusic()
            } else {
                objectNode?.removeFromParent()
                shieldObject.removeAllChildren()
                shieldBool = false
                if sound == true { run(shieldOffPreload) }
            }
        }
        
        if contact.bodyA.categoryBitMask == shieldGroup || contact.bodyB.categoryBitMask == shieldGroup {
            levelUp()
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
            levelUp() 
            let coinNode = contact.bodyA.categoryBitMask == coinGroup ? contact.bodyA.node: contact.bodyB.node
            
            if sound == true {
                run(pickCoinPreload)
            }
            
            switch stageLabel.text! {
            case "Stage 1":
                if gSceneDifficulty.rawValue == 0 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 1
                } else if gSceneDifficulty.rawValue == 1 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 2
                } else if gSceneDifficulty.rawValue == 2 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 3
                }
            case "Stage 2":
                if gSceneDifficulty.rawValue == 0 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 2
                } else if gSceneDifficulty.rawValue == 1 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 3
                } else if gSceneDifficulty.rawValue == 2 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 4
                }
            case "Stage 3":
                if gSceneDifficulty.rawValue == 0 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 3
                } else if gSceneDifficulty.rawValue == 1 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 4
                } else if gSceneDifficulty.rawValue == 2 {
                    Model.sharedInstance.score = Model.sharedInstance.score + 5
                }
            default:break
            }
            
            scoreLabel.text = "\(Model.sharedInstance.score)"
            
            coinNode?.removeFromParent()
            
        }
        UserDefaults.standard.set(Model.sharedInstance.totalscore, forKey: "totalscore")
    }
    
}

