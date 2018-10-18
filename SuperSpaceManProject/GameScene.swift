//
//  GameScene.swift
//  SuperSpaceManProject
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Apress. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background") //is SKSpriteNode -> is descendant of an SKNode
    let playerNode = SKSpriteNode(imageNamed: "Player") //is SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){ //represents the size for the scene to be
        super.init(size: size)
        backgroundNode.size.width = frame.size.width //determine width of view's frame
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0) //determine where the new node will be anchored in my scene
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0) //setting node's position
        addChild(backgroundNode)
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        addChild(playerNode)
    }
}
