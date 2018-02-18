//
//  GameViewController.swift
//  Sprite1
//
//  Created by Анастасия Арсений on 21.01.18.
//  Copyright © 2018 Анастасия Арсений. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene = GameScene(size: CGSize(width: 1024, height: 768))
    let textureAtlas = SKTextureAtlas(named: "scene.atlas")
    
    //Variables
    var gVCBgChoosing: BgCoosing!
    var gVCDifficulty: DifficultyChoosing!
    
    
    @IBOutlet weak var reloadGameBtn: UIButton!
    @IBOutlet weak var returnMainBtn: UIButton!
    @IBOutlet weak var loadingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.isHidden = false
        
        reloadGameBtn.isHidden = true
        
        let view = self.view as! SKView
        
        view.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFill
        scene.gSceneBg = gVCBgChoosing
        scene.gSceneDifficulty = gVCDifficulty
        scene.gameViewControllerBridge = self
        
        textureAtlas.preload {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.loadingView.isHidden = true
                view.presentScene(self.scene)
            })
        
        }
    }
    @IBAction func reloadGameButton(sender: UIButton) {
        scene.reloadGame()
        scene.gameViewControllerBridge = self
        reloadGameBtn.isHidden = true
    }
    
    @IBAction func returnSelectBackGround(sender: UIButton) {
        navigationController?.popViewController(animated: false)
        navigationController?.dismiss(animated: false, completion: nil)
        
        DispatchQueue.main.async {
            self.scene.removeAll()
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
