//
//  GameScene.swift
//  SuperSpaceManProject
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Apress. All rights reserved.
//

import SpriteKit
import CoreMotion // to use accelerometer

class GameScene: SKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background") //is SKSpriteNode -> is descendant of an SKNode
    let foregroundNode = SKSpriteNode() //will hold all the sprites that will affect game play
    let playerNode = SKSpriteNode(imageNamed: "Player") //is SKSpriteNode
    //let orbNode = SKSpriteNode(imageNamed: "PowerUp")
    var impulseCount = 4 //maximum tap on screen is 4
    let coreMotionManager = CMMotionManager()
    
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1 //collision bit masks are 32 bits
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){ //represents the size for the scene to be
        super.init(size: size)
        physicsWorld.contactDelegate = self 
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0); // to modify the world's gravity using the SKScene's physicsWorld.gravity
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        isUserInteractionEnabled = true
        
        //adding the beckground
        backgroundNode.size.width = frame.size.width //determine width of view's frame
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0) //determine where the new node will be anchored in my scene
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0) //setting node's position
        addChild(backgroundNode)
        addChild(foregroundNode)
        
        
        
        //adding the player
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        playerNode.physicsBody?.isDynamic = false //the player doesn't fall off the screen if user don't tap the screen in time
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 180.0)//determine size and position of player
        
        playerNode.physicsBody?.linearDamping = 1.0 //to reduce a physics body’s linear velocity to simulate fluid or air friction. OR to maintain speed of player's gravity
        
        playerNode.physicsBody?.allowsRotation = false//the playerNode to just keep blasting through the orbs without spinning off
       
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer //associates the playerNode.physicsBody’s category bit mask to the CollisionCategoryPlayer.
       
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs //tells SpriteKit that whenever your physics body comes into contact with another physics body belonging to the category CollisionCategoryPowerUpOrbs, you want to be notified.
        
        playerNode.physicsBody?.collisionBitMask = 0
        foregroundNode.addChild(playerNode)
        
        //CODE BELOW IS USED TO ADD SINGLE NODE
        
//        orbNode.position = CGPoint(x: 180.0, y: size.height - 40)//determine size and position of orb
//        orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
//        orbNode.physicsBody?.isDynamic = false//orb's position will be static
//        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs// associates the orbNode’s physics body to the category CollisionCategoryPowerUpOrbs,
//        orbNode.physicsBody?.collisionBitMask = 0// configuring the player, is set to 0 because you’re going to handle collisions yourself
//        orbNode.name = "POWER_UP_ORB"//name of orbNode
//        foregroundNode.addChild(orbNode)
        
        var orbNodePosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 100)//y-coordinate prosition of orbNode is 100 points above the playerNode
        for _ in 0...19 { //The underscore (_) means never used in the prgramming
            //this looping to adds 20 orbNode objects centered above the player
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            orbNodePosition.y += 140 //the position of each node is 140 points above the previous node's anchorPoint
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false //the orb position is static
            
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            
            foregroundNode.addChild(orbNode)
        }
        
        orbNodePosition = CGPoint(x: playerNode.position.x + 50, y: orbNodePosition.y)// the position of the other 20 nodes will be greater 50 points of x-coordinate than  playerNode position
            for _ in 0...19 { //The underscore (_) means never used in the prgramming
                //this looping to adds 20 orbNode objects centered above the player
                let orbNode = SKSpriteNode(imageNamed: "PowerUp")
                orbNodePosition.y += 140 //the position of each node is 140 points above the previous node's anchorPoint
                orbNode.position = orbNodePosition
                orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
                orbNode.physicsBody?.isDynamic = false //the orb position is static
                
                orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
                orbNode.physicsBody?.collisionBitMask = 0
                orbNode.name = "POWER_UP_ORB"
                
                foregroundNode.addChild(orbNode)
        }
        
    }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //applies an impulse to the playerNode’s physics body every time user tap the screen
        if !playerNode.physicsBody!.isDynamic {
            playerNode.physicsBody?.isDynamic = true
            
            coreMotionManager.accelerometerUpdateInterval = 0.3 //tells the coreMotionManager the interval, in seconds, which is 3/10 of a second
            coreMotionManager.startAccelerometerUpdates()//starts the accelerometer updates
        }
        
        if impulseCount > 0 {
            playerNode.physicsBody!.applyImpulse(CGVector(dx:0.0, dy: 40.0))
            impulseCount -= 1
        }
       // playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
        //the x-value to apply the impulse only linearly along the y-axis
        //the y value to show which results in a pulse that springs the player in the opposite direction of gravity.
    }
    
    override func update(_ currentTime: TimeInterval) {
        if playerNode.position.y >= 180.0 {
            backgroundNode.position =
                CGPoint(x: backgroundNode.position.x,
                        y: -((playerNode.position.y - 180.0)/8))
            
            foregroundNode.position =
                CGPoint(x: foregroundNode.position.x,
                        y: -(playerNode.position.y - 180.0))
        }
    }
    
    override func didSimulatePhysics(){
        if let accelerometerData = coreMotionManager.accelerometerData {
            playerNode.physicsBody!.velocity =
                CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380.0), dy: playerNode.physicsBody!.velocity.dy)
        }
        if playerNode.position.x < -(playerNode.size.width / 2) {
            playerNode.position =
                CGPoint(x: size.width - playerNode.size.width / 2,
                        y: playerNode.position.y)
        }
            
        else if playerNode.position.x > self.size.width {
            playerNode.position =
                CGPoint(x: playerNode.size.width / 2,
                        y: playerNode.position.y);
        }
    }
    
    deinit {
        coreMotionManager.stopAccelerometerUpdates()//turning off the accelerometer when the GameScene is no longer used
    }
    
}


extension GameScene: SKPhysicsContactDelegate { //To be able to detect when SKNodes come into contact with each other
    func didBegin(_ contact: SKPhysicsContact) {// invoked when the contact first begins
        let nodeB = contact.bodyB.node //The bodyB property, an SKPhysicsBody, represents second body in the contact. (This will be the orbNode.)
        if nodeB?.name == "POWER_UP_ORB" {
            impulseCount += 1
            nodeB?.removeFromParent()//removes the orbNode from the scene.
            }
        }
    }



