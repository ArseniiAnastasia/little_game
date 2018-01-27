//
//  GameScene.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 21.01.18.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Texture
    var bgTexture: SKTexture!
    var runHeroTex: SKTexture!
    
    
    //Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var hero = SKSpriteNode()
    
    
    //Sprite Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var heroObject = SKNode()
    
    //Bit Masks
    var heroGroup: UInt32 = 0x1 << 1
    var groungGroup: UInt32 = 0x1 << 2
    
    
    //Texture Array for Animation
    var heroRunTexturesArray = [SKTexture]()
    
    
    override func didMove(to view: SKView) {
        
        //Background texture
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        //Hero Texture
        runHeroTex = SKTexture(imageNamed: "run01.png")
        
        
        createObjects()
        createGame()
        
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(heroObject)
        
    }
    
    func createGame() {
        createBg()
        createGround()
        createHero()
        
    }
    
    func createBg(){
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 4)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
    
        for i in 0..<3 {
          bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: size.width/4 + bgTexture.size().width * CGFloat(i), y: size.height/2.0)
            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            bg.zPosition = -1
            
            bgObject.addChild(bg)
        }
    }
   
    func createGround() {
        ground = SKSpriteNode()
        ground.position = CGPoint.zero
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height/4 + self.frame.height/20))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.contactTestBitMask = groungGroup
        ground.zPosition = 1
        
        groundObject.addChild(ground)
        
    }
    
    func addHero(heroNode: SKSpriteNode, atPosition position: CGPoint){
        hero = SKSpriteNode(texture: runHeroTex)
        
        //Anim hero
        heroRunTexturesArray = [SKTexture(imageNamed: "run01.png"), SKTexture(imageNamed: "run02.png"), SKTexture(imageNamed: "run03.png"), SKTexture(imageNamed: "run04.png")]
        
        let heroRunAnimation = SKAction.animate(with: heroRunTexturesArray, timePerFrame: 0.1)
        let runHero = SKAction.repeatForever(heroRunAnimation)
        hero.run(runHero)
        
        hero.position = position
        hero.size.height = 84
        hero.size.width = 120
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))
        
        hero.physicsBody?.categoryBitMask = heroGroup
        hero.physicsBody?.contactTestBitMask = groungGroup
        hero.physicsBody?.contactTestBitMask = groungGroup
        
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.zPosition = 1
        
        
        
        heroObject.addChild(hero)
        

        
    }
    
    func createHero() {
        addHero(heroNode: hero, atPosition: CGPoint(x: self.size.width/4, y: 0 + runHeroTex.size().height + 400))
    }
    
}






