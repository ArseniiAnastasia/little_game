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
    
    
    //Animations
    var animations = AnimationClass()
    
    //Variables
    var sound = true
    var gameViewControllerBridge: GameViewController!
    var moveElectricGateY = SKAction()
    var shieldBool = false
    var gameover = 0
    var gSceneDifficulty: DifficultyChoosing!
    var gSceneBg: BgCoosing! 
   
    
    //Texture
    var bgTexture: SKTexture!
    var runHeroTex: SKTexture!
    var coinTex: SKTexture!
    var coinHeroTex: SKTexture!
    var electricTex: SKTexture!
    var shieldTex: SKTexture!
    var shieldItemTex: SKTexture!
    var mine1Tex: SKTexture!
    var mine2Tex: SKTexture!
    
    //Label Nodes
    var tabToPlayLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var highscoreLabel = SKLabelNode()
    var highscoreTextLabel = SKLabelNode()
    var stageLabel = SKLabelNode()
    
    
    //Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var hero = SKSpriteNode()
    var coin = SKSpriteNode()
    var electricGate = SKSpriteNode()
    var shield = SKSpriteNode()
    var shieldItem = SKSpriteNode()
    var mine = SKSpriteNode()
    
    
    //Sprite Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var movingObject = SKNode()
    var heroObject = SKNode()
    var coinObject = SKNode()
    var shieldObject = SKNode()
    var shieldItemObject = SKNode()
    var labelObject = SKNode()
    
    //Bit Masks
    var heroGroup: UInt32 = 0x1 << 1
    var groungGroup: UInt32 = 0x1 << 2
    var coinGroup: UInt32 = 0x1 << 3
    var objectGroup: UInt32 = 0x1 << 4
    var shieldGroup: UInt32 = 0x1 << 5
    
    
    
    //Texture Array for Animation
    var heroRunTexturesArray = [SKTexture]()
    var coinTexturesArray = [SKTexture]()
    var electricTexturesArray = [SKTexture]()
    
    
    //Timers
    var timerAddCoin = Timer()
    var timerAddElectricGate = Timer()
    var timerAddShieldItem = Timer()
    var timerAddMine = Timer()
    
    //Sounds
    var pickCoinPreload = SKAction()
    var electricGateCreatePreload = SKAction()
    var shieldOnPreload = SKAction()
    var shieldOffPreload = SKAction()
    
    
    override func didMove(to view: SKView) {
        
        //Background texture
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        //Hero Texture
        runHeroTex = SKTexture(imageNamed: "run01.png")
        
        //Coin Texture
        coinTex = SKTexture(imageNamed: "coin.jpg")
        coinHeroTex = SKTexture(imageNamed: "coin0.png")
        
        //ElectricGate texture
        electricTex = SKTexture(imageNamed: "ElectricGate01.png")
        
        //Shields texture
        shieldTex = SKTexture(imageNamed: "shield.png")
        shieldItemTex = SKTexture(imageNamed: "shieldItem.png")
        
        //Mines texture
        mine1Tex = SKTexture(imageNamed: "mine1.png")
        mine2Tex = SKTexture(imageNamed: "mine2.png")
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        
        if UserDefaults.standard.object(forKey: "highScore") != nil {
            Model.sharedInstance.highscore = UserDefaults.standard.object(forKey: "highScore") as! Int
            highscoreLabel.text = "\(Model.sharedInstance.highscore)"
        }
        
        if UserDefaults.standard.object(forKey: "totalscore") != nil {
            Model.sharedInstance.totalscore = UserDefaults.standard.object(forKey: "totalscore") as! Int
        }
        
        if gameover == 0 {
        createGame()
            
        }
        pickCoinPreload = SKAction.playSoundFileNamed("pickCoin.mp3", waitForCompletion: false)
        electricGateCreatePreload = SKAction.playSoundFileNamed("electricCreate.wav", waitForCompletion: false)
        shieldOnPreload = SKAction.playSoundFileNamed("shieldOn.mp3", waitForCompletion: false)
        shieldOffPreload = SKAction.playSoundFileNamed("shieldOff.mp3", waitForCompletion: false)
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(movingObject)
        self.addChild(heroObject)
        self.addChild(coinObject)
        self.addChild(shieldObject)
        self.addChild(shieldItemObject)
        self.addChild(labelObject)
    }
    
    func createGame() {
        createBg()
        createGround()
        createHero()
        timerFunc()
        addElectricGate()
        
    
    showTapToPlay()
    showScore()
    showStage()
    highscoreTextLabel.isHidden = true
    
    gameViewControllerBridge.reloadGameBtn.isHidden = true
    gameViewControllerBridge.returnMainBtn.isHidden = true
    
    if labelObject.children.count != 0 {
    labelObject.removeAllChildren()
    }
}
    
    func createBg(){
        //bgTexture = SKTexture(imageNamed: "bg01.png")
        switch gSceneBg.rawValue {
        case 0:
            bgTexture = SKTexture(imageNamed: "bg01.png")
        case 1:
            bgTexture = SKTexture(imageNamed: "bg02.png")
        default:
            break
        }
        
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
        hero.physicsBody?.contactTestBitMask = groungGroup | coinGroup | objectGroup | shieldGroup
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
        coinTexturesArray = [SKTexture(imageNamed: "coin0.png"), SKTexture(imageNamed: "coin1.png"), SKTexture(imageNamed: "coin2.png"), SKTexture(imageNamed: "coin3.png")]
        
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
    
    
    @objc func addElectricGate() {
    if sound == true {
        run(electricGateCreatePreload)
    }
    
    electricGate = SKSpriteNode(texture: electricTex)
    
    electricTexturesArray = [SKTexture(imageNamed: "ElectricGate01.png"), SKTexture(imageNamed: "ElectricGate02.png"), SKTexture(imageNamed: "ElectricGate03.png"), SKTexture(imageNamed: "ElectricGate04.png")]
    
    let electricAnimation = SKAction.animate(with: electricTexturesArray, timePerFrame: 0.1)
    let electricHero = SKAction.repeatForever(electricAnimation)
        electricGate.run(electricHero)
        
    let randomPosition = arc4random() % 2
    let movementAmount = arc4random() % UInt32(self.frame.size.height / 5)
    let pipeOffset = self.frame.size.height / 4 + 30 - CGFloat(movementAmount)
    
    if randomPosition == 0 {
        electricGate.position = CGPoint(x: self.size.width + 50, y: 0 + electricTex.size().height/2 + 90 + pipeOffset)
        electricGate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: electricGate.size.width - 40, height: electricGate.size.height - 20))
    } else {
        electricGate.position = CGPoint(x: self.size.width + 50, y: self.frame.size.height - electricTex.size().height/2 - 90 - pipeOffset)
        electricGate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: electricGate.size.width - 40, height: electricGate.size.height - 20))
    }
    
    //Rotate
    electricGate.run(SKAction.repeatForever(SKAction.sequence([SKAction.run({
        self.electricGate.run(SKAction.rotate(byAngle: CGFloat(Double.pi * 2), duration: 0.5))
    }), SKAction.wait(forDuration: 20.0)])))
    
    //Move
    let moveAction = SKAction.moveBy(x: -self.frame.width - 300, y: 0, duration: 6)
    electricGate.run(moveAction)
    
    //Scale
    var scaleValue: CGFloat = 0.3
    
    
    let scaleRandom = arc4random() % UInt32(5)
    if scaleRandom == 1 { scaleValue = 0.9 }
    else if scaleRandom == 2 { scaleValue = 0.6 }
    else if scaleRandom == 3 { scaleValue = 0.8 }
    else if scaleRandom == 4 { scaleValue = 0.7 }
    else if scaleRandom == 0 { scaleValue = 1.0 }
    
    electricGate.setScale(scaleValue)
    
    let movementRandom = arc4random() % 9
    if movementRandom == 0 {
        moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 220, duration: 4)
    } else if movementRandom == 1 {
        moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 220, duration: 5)
    } else if movementRandom == 2 {
        moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 150, duration: 4)
    } else if movementRandom == 3 {
        moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 150, duration: 5)
    } else if movementRandom == 4 {
        moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 50, duration: 4)
    } else if movementRandom == 5 {
        moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 50, duration: 5)
    } else {
        moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2, duration: 4)
    }
    
    electricGate.run(moveElectricGateY)
    
    electricGate.physicsBody?.restitution = 0
    electricGate.physicsBody?.isDynamic = false
    electricGate.physicsBody?.categoryBitMask = objectGroup
    electricGate.zPosition = 1
    movingObject.addChild(electricGate)
}

    @objc func addMine() {
    mine = SKSpriteNode(texture: mine1Tex)
    let minesRandom = arc4random() % UInt32(2)
    if minesRandom == 0 {
        mine = SKSpriteNode(texture: mine1Tex)
    } else {
        mine = SKSpriteNode(texture: mine2Tex)
    }
    
    mine.size.width = 70
    mine.size.height = 62
    mine.position = CGPoint(x: self.frame.size.width + 150, y: self.frame.size.height / 4 - self.frame.size.height / 24)
    
    let moveMineX = SKAction.moveTo(x: -self.frame.size.width / 4, duration: 4)
    mine.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mine.size.width - 40, height: mine.size.height - 30))
    mine.physicsBody?.categoryBitMask = objectGroup
    mine.physicsBody?.isDynamic = false
    
    let removeAction = SKAction.removeFromParent()
    let mineMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveMineX, removeAction]))
    
    animations.rotateAnimationToAngle(sprite: mine, animDuration: 0.2)
    
    mine.run(mineMoveBgForever)
    mine.zPosition = 1
    movingObject.addChild(mine)
}

func addShield() {
    shield = SKSpriteNode(texture: shieldTex)
    if sound == true { run(shieldOnPreload) }
    shield.size.width = 150
    shield.size.height = 150
    
    shield.zPosition = 1
    shieldObject.addChild(shield)
}

    @objc func addShieldItem() {
    shieldItem = SKSpriteNode(texture: shieldItemTex)
    
    let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
    let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
    
    shieldItem.position = CGPoint(x: self.size.width + 50, y: 0 + shieldItemTex.size().height + self.size.height / 2 + pipeOffset)
    shieldItem.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldItem.size.width - 20, height: shieldItem.size.height - 20))
    shieldItem.physicsBody?.restitution = 0
    
    let moveShield = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
    let removeAction = SKAction.removeFromParent()
    let shieldItemMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveShield, removeAction]))
    shieldItem.run(shieldItemMoveBgForever)
    
    animations.scaleZdirection(sprite: shieldItem)
    shieldItem.setScale(1.1)
    
    shieldItem.physicsBody?.isDynamic = false
    shieldItem.physicsBody?.categoryBitMask = shieldGroup
    shieldItem.zPosition = 1
    shieldItemObject.addChild(shieldItem)
    
}

func showTapToPlay() {
    tabToPlayLabel.text = "Tap to jump!!!"
    tabToPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    tabToPlayLabel.fontSize = 50
    tabToPlayLabel.fontColor = UIColor.green
    tabToPlayLabel.fontName = "Chalkduster"
    tabToPlayLabel.zPosition = 1
    self.addChild(tabToPlayLabel)
}

func showScore() {
    scoreLabel.fontName = "Chalkduster"
    scoreLabel.text = "0"
    scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 200)
    scoreLabel.fontSize = 60
    scoreLabel.fontColor = UIColor.red
    scoreLabel.zPosition = 1
    self.addChild(scoreLabel)
}

func showHighscore() {
    highscoreLabel = SKLabelNode()
    highscoreLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 210)
    highscoreLabel.fontSize = 50
    highscoreLabel.fontName = "Chalkduster"
    highscoreLabel.fontColor = UIColor.red
    highscoreLabel.isHidden = true
    highscoreLabel.zPosition = 1
    labelObject.addChild(highscoreLabel)
}

func showHighscoreText() {
    //highscoreTextLabel = SKLabelNode()
    highscoreTextLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 150)
    highscoreTextLabel.fontSize = 30
    highscoreTextLabel.fontName = "Chalkduster"
    highscoreTextLabel.fontColor = UIColor.red
    highscoreTextLabel.text = "HighScore"
    highscoreTextLabel.zPosition = 1
    labelObject.addChild(highscoreTextLabel)
}

func showStage() {
    stageLabel.position = CGPoint(x: self.frame.maxX - 60, y: self.frame.maxY - 140)
    stageLabel.fontSize = 30
    stageLabel.fontName = "Chalkduster"
    stageLabel.fontColor = UIColor.red
    stageLabel.text = "Stage 1"
    stageLabel.zPosition = 1
    self.addChild(stageLabel)
}
    
    func levelUp() {
        if 1 <= Model.sharedInstance.score && Model.sharedInstance.score < 20 {
            stageLabel.text = "Stage 1"
            coinObject.speed = 1.05
            movingObject.speed = 1.05
            
            self.speed = 1.05
        } else if 20 <= Model.sharedInstance.score && Model.sharedInstance.score < 36 {
            stageLabel.text = "Stage 2"
            coinObject.speed = 1.22
            movingObject.speed = -1.22
            
            self.speed = 1.22
        } else if 36 <= Model.sharedInstance.score && Model.sharedInstance.score < 56 {
            stageLabel.text = "Stage 3"
            coinObject.speed = 1.3
            movingObject.speed = 1.3
            self.speed = 1.3
        }
    }

func timerFunc() {
    
    timerAddCoin.invalidate()
    timerAddElectricGate.invalidate()
    timerAddMine.invalidate()
    timerAddShieldItem.invalidate()
    
    timerAddCoin = Timer.scheduledTimer(timeInterval: 2.64, target: self, selector: #selector(GameScene.addCoin), userInfo: nil, repeats: true)
    
    switch gSceneDifficulty.rawValue {
    case 0: //easy
        timerAddElectricGate = Timer.scheduledTimer(timeInterval: 5.234, target: self, selector: #selector(GameScene.addElectricGate), userInfo: nil, repeats: true)
        timerAddMine = Timer.scheduledTimer(timeInterval: 4.245, target: self, selector: #selector(GameScene.addMine), userInfo: nil, repeats: true)
        
        timerAddShieldItem = Timer.scheduledTimer(timeInterval: 20.246, target: self, selector: #selector(GameScene.addShieldItem), userInfo: nil, repeats: true)
    case 1: //medium
        timerAddElectricGate = Timer.scheduledTimer(timeInterval: 3.234, target: self, selector: #selector(GameScene.addElectricGate), userInfo: nil, repeats: true)
        timerAddMine = Timer.scheduledTimer(timeInterval: 3.245, target: self, selector: #selector(GameScene.addMine), userInfo: nil, repeats: true)
        
        
        timerAddShieldItem = Timer.scheduledTimer(timeInterval: 30.246, target: self, selector: #selector(GameScene.addShieldItem), userInfo: nil, repeats: true)
    case 2: //hard
        timerAddElectricGate = Timer.scheduledTimer(timeInterval: 3.034, target: self, selector: #selector(GameScene.addElectricGate), userInfo: nil, repeats: true)
        timerAddMine = Timer.scheduledTimer(timeInterval: 2.945, target: self, selector: #selector(GameScene.addMine), userInfo: nil, repeats: true)
       
        
        timerAddShieldItem = Timer.scheduledTimer(timeInterval: 40.246, target: self, selector: #selector(GameScene.addShieldItem), userInfo: nil, repeats: true)
    default: break
    }
    
}

func stopGameObject() {
    coinObject.speed = 0
    movingObject.speed = 0
    heroObject.speed = 0
}

func reloadGame() {
    
    if sound == true {
        SKTAudio.sharedInstance().resumeBackgroundMusic()
    }
    coinObject.removeAllChildren()
    
    stageLabel.text = "Stage 1"
    gameover = 0
    scene?.isPaused = false
    
    movingObject.removeAllChildren()
    heroObject.removeAllChildren()
    
    coinObject.speed = 1
    heroObject.speed = 1
    movingObject.speed = 1
    self.speed = 1
    
    if labelObject.children.count != 0 {
        labelObject.removeAllChildren()
    }
    
    createGround()
    createHero()
    
    gameViewControllerBridge.returnMainBtn.isHidden = true
    
    Model.sharedInstance.score = 0
    scoreLabel.text = "0"
    stageLabel.isHidden = false
    highscoreTextLabel.isHidden = true
    showHighscore()
    
    timerAddCoin.invalidate()
    timerAddElectricGate.invalidate()
    timerAddMine.invalidate()
    timerAddShieldItem.invalidate()
    
    timerFunc()
}
override func didFinishUpdate() {
    
    shield.position = hero.position + CGPoint(x: 0, y: 0)
    }

    
    
    func removeAll() {
        Model.sharedInstance.score = 0
        scoreLabel.text = "0"
        
        gameover = 0
        
        if labelObject.children.count != 0 {
            labelObject.removeAllChildren()
        }
        
        timerAddCoin.invalidate()
        timerAddElectricGate.invalidate()
        timerAddMine.invalidate()
        timerAddShieldItem.invalidate()
        
        
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
        self.view?.removeFromSuperview()
        gameViewControllerBridge = nil
        }
    }






