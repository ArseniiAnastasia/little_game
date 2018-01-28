//
//  GameScene.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 21.01.18.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Texture
    var bgTexture: SKTexture!
    var runHeroTex: SKTexture!
    var coinTex: SKTexture!
    var coinHeroTex: SKTexture!
    
    
    //Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var hero = SKSpriteNode()
    var coin = SKSpriteNode()
    
    
    //Sprite Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var heroObject = SKNode()
    var coinObject = SKNode()
    
    //Bit Masks
    var heroGroup: UInt32 = 0x1 << 1
    var groungGroup: UInt32 = 0x1 << 2
    var coinGroup: UInt32 = 0x1 << 3
    
    
    
    //Texture Array for Animation
    var heroRunTexturesArray = [SKTexture]()
    var coinTexturesArray = [SKTexture]()
    
    //Temers
    var timerAddCoin = Timer()
    
    
    
    override func didMove(to view: SKView) {
        
        //Background texture
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        //Hero Texture
        runHeroTex = SKTexture(imageNamed: "run01.png")
        
        //Coin Texture
        coinTex = SKTexture(imageNamed: "coin.jpg")
        coinHeroTex = SKTexture(imageNamed: "coin0.png")
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        createGame()
        
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(heroObject)
        self.addChild(coinObject)
        
    }
    
    func createGame() {
        createBg()
        createGround()
        createHero()
        timerFunc()
        
    }
    
    func createBg(){
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 4)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
    
        for i in 0..<3 {
          bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: size.width/4 + bgTexture.size().width * CGFloat(i), y: size.height/1.8)
            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            bg.zPosition = -1
            
            bgObject.addChild(bg)
        }
    }
   
    func createGround() {
        ground = SKSpriteNode()
        ground.position = CGPoint.zero
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height/4 + self.frame.height/7))
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
        hero.physicsBody?.contactTestBitMask = groungGroup | coinGroup
        hero.physicsBody?.collisionBitMask = groungGroup
        
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.zPosition = 1
        
        
        
        heroObject.addChild(hero)
        

        
    }
    
    func createHero() {
        addHero(heroNode: hero, atPosition: CGPoint(x: self.size.width/4, y: 0 + runHeroTex.size().height + 400))
    }
    
    @objc func addCoin() {
      coin = SKSpriteNode(texture: coinTex)
        coinTexturesArray = [SKTexture(imageNamed: "coin0.png"), SKTexture(imageNamed: "coin1.png"), SKTexture(imageNamed: "coin3.png")]
        
        let coinAnimation = SKAction.animate(with: coinTexturesArray, timePerFrame: 0.1)
        let coinHero = SKAction.repeatForever(coinAnimation)
        coin.run(coinHero)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height/2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height/4
        coin.size.width = 50
        coin.size.height = 50
        coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: coin.size.width - 20, height: coin.size.height - 20))
        coin.physicsBody?.restitution = 0
        coin.position = CGPoint(x: self.size.width + 50, y: 0 + coinTex.size().height + 90 + pipeOffset)
        
        let moveCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let coinMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveCoin,removeAction]))
        coin.run(coinMoveBgForever)
        
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = coinGroup
        coin.zPosition = 1
        coinObject.addChild(coin)
        
    
    }
    
    func timerFunc() {
        timerAddCoin.invalidate()
        
        timerAddCoin = Timer.scheduledTimer(timeInterval: 2.63, target: self, selector: #selector(GameScene.addCoin), userInfo: nil, repeats: true)
        
        
    }
    
}






