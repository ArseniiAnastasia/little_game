//
//  Animations.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 12.02.2018.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import Foundation
import SpriteKit


class AnimationClass {
    
    func scaleZdirection(sprite: SKSpriteNode) {
        sprite.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.scale(by: 2.0, duration: 0.5),
                SKAction.scale(to: 1.0, duration: 1.0)
                ])
        ))
    }
    
    
    func rotateAnimationToAngle(sprite: SKSpriteNode, animDuration: TimeInterval) {
        sprite.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.rotate(toAngle: CGFloat(Double.pi/2), duration: animDuration),
            SKAction.rotate(toAngle: CGFloat(Double.pi), duration: animDuration),
            SKAction.rotate(toAngle: CGFloat(-Double.pi/2), duration: animDuration),
            SKAction.rotate(toAngle: CGFloat(Double.pi), duration: animDuration)
            ])))
    }
    
   
}

