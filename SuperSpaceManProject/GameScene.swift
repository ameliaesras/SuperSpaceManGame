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
    let orbNode = SKSpriteNode(imageNamed: "PowerUp")
    
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1 //collision bit masks are 32 bits
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){ //represents the size for the scene to be
        super.init(size: size)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0); // to modify the world's gravity using the SKScene's physicsWorld.gravity
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        isUserInteractionEnabled = true
        
        //adding the beckground
        backgroundNode.size.width = frame.size.width //determine width of view's frame
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0) //determine where the new node will be anchored in my scene
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0) //setting node's position
        addChild(backgroundNode)
        
        //adding the player
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        playerNode.physicsBody?.isDynamic = true
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)//determine size and position of player
        
        playerNode.physicsBody?.linearDamping = 1.0 //to reduce a physics body’s linear velocity to simulate fluid or air friction. OR to maintain speed of player's gravity
        
        playerNode.physicsBody?.allowsRotation = false//the playerNode to just keep blasting through the orbs without spinning off
       
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer //associates the playerNode.physicsBody’s category bit mask to the CollisionCategoryPlayer.
       
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs //tells SpriteKit that whenever your physics body comes into contact with another physics body belonging to the category CollisionCategoryPowerUpOrbs, you want to be notified.
        
        playerNode.physicsBody?.collisionBitMask = 0
        addChild(playerNode)
        
        orbNode.position = CGPoint(x: 180.0, y: size.height - 40)//determine size and position of orb
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
        orbNode.physicsBody?.isDynamic = false//orb's position will be static
        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs// associates the orbNode’s physics body to the category CollisionCategoryPowerUpOrbs,
        orbNode.physicsBody?.collisionBitMask = 0// configuring the player, is set to 0 because you’re going to handle collisions yourself
        orbNode.name = "POWER_UP_ORB"//name of orbNode
        addChild(orbNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //applies an impulse to the playerNode’s physics body every time user tap the screen
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
        //the x-value to apply the impulse only linearly along the y-axis
        //the y value to show which results in a pulse that springs the player in the opposite direction of gravity.
    }
}

extension GameScene: SKPhysicsContactDelegate { //To be able to detect when SKNodes come into contact with each other
    func didBegin(_ contact: SKPhysicsContact) {// invoked when the contact first begins
        let nodeB = contact.bodyB.node //The bodyB property, an SKPhysicsBody, represents second body in the contact. (This will be the orbNode.)
        if nodeB?.name == "POWER_UP_ORB" {
            nodeB?.removeFromParent()//removes the orbNode from the scene.
        }
    }
}
