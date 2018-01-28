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
        if contact.bodyA.categoryBitMask == coinGroup || contact.bodyB.categoryBitMask == coinGroup {
            let coinNode = contact.bodyA.categoryBitMask == coinGroup ? contact.bodyA.node: contact.bodyB.node
            
            coinNode?.removeFromParent()
            
        }
    }
    
}

