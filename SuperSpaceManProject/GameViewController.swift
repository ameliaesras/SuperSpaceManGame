//
//  GameViewController.swift
//  SuperSpaceManProject
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Apress. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    
    override var prefersStatusBarHidden: Bool { //to hide the status bar when game is started
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Configure the main view
        let skView = view as! SKView
        skView.showsFPS = true //use to show/hide frame per second
        
        //2. Create and configure our game scene
        scene = GameScene(size: skView.bounds.size)// initializing the size to match the size of the view that will be host the scene
        scene.scaleMode = .aspectFill //determine how the scene will be scaled to match the view that will contain it
        
        //3. Show the scene
        skView.presentScene(scene)
    }
}
