//
//  GameScene.swift
//  SpriteKitGame
//
//  Created by Kishore Narang on 2020-06-08.
//  Copyright © 2020 Kishore Narang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var lastUpdateTime:TimeInterval = 0
    var dt:TimeInterval = 0
    var zombieMovePointPerSecond:CGFloat = 500.00
    var velocity:CGPoint = .zero
    
    let playableRect:CGRect
    
    //to stop the moving of zombie challange 2 chapter 2
    
    var lastTouchedLocation:CGPoint?
    
    
    override init(size:CGSize)
    {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.height / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        playableRect = CGRect(x:0.0,
                              y:playableMargin,
                              width: size.width,
                              height: playableHeight)
        
        super.init(size:size)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("Error: init(coder:) is not implemented")
    }
    override func didMove(to view: SKView) {
    backgroundColor = SKColor.purple
        
        
        let background = SKSpriteNode(imageNamed: "background1")
        //background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = .zero
        //background.zRotation = CGFloat(Double.pi)/8
        background.zPosition = -1;
        addChild(background)
        
        zombie.position = CGPoint(x: 400, y: 400)
        addChild(zombie)
        spawnEnemy()
        debugDrawPlayableArea()
        
      
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if(lastUpdateTime>0)
        {
            dt = currentTime - lastUpdateTime
        }
        else
        {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        print("\(dt*1000) milliseconds since last updATE")
        
        //zombie move smoothly.
        
        
        //zombie.position = CGPoint(x: zombie.position.x + 8, y: zombie.position.y)
        boundCheckZombie()
        move(sprite: zombie, velocity: velocity)
        rotate(sprite: zombie, direction: velocity)
        
    }
    func move(sprite:SKSpriteNode, velocity:CGPoint)
    {
        //1
        let amountToMove = CGPoint(x:velocity.x * CGFloat(dt), y:velocity.y * CGFloat(dt))
        //print("Amount To Move / second is \(amountToMove)")
        //sprite.position = CGPoint(x:sprite.position.x + amountToMove.x,
            //        y:sprite.position.y + amountToMove.y)
        //aftter adding MyUtils.swift the above commented code will look like
        sprite.position += amountToMove
        
    }
    func moveZombieToward(point:CGPoint)
    {
        let offset = CGPoint(x:point.x - zombie.position.x,
                             y:point.y - zombie.position.y)
        
        let length = sqrt(Double(offset.x*offset.x + offset.y*offset.y))
        
        
        //unit vector.
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        
        velocity = CGPoint(x: direction.x * self.zombieMovePointPerSecond,
                               y: direction.y * self.zombieMovePointPerSecond)
        
        
        
        
    }
    
    
    
    func sceneTouched(location:CGPoint)
    {
        moveZombieToward(point: location)
    }
    
    //touches began
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return }
        let touchLocation = touch.location(in: self)
        sceneTouched(location: touchLocation)
        print("Scene touched at \(touchLocation)")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           guard let touch = touches.first else {return }
           let touchLocation = touch.location(in: self)
           sceneTouched(location: touchLocation)
           
       }
    
    
    //:Phase 4 Bound Check Zombie.
    
    func boundCheckZombie()
    {
        let bottomLeft = CGPoint(x:0,
                                 y:playableRect.minY)
        let topRight = CGPoint(x:size.width,
                               y:playableRect.maxY)
        
        if(zombie.position.x <= bottomLeft.x )
        {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if(zombie.position.x>=topRight.x)
        {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if(zombie.position.y>=topRight.y)
        {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
        if(zombie.position.y <= bottomLeft.y)
        {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
    }
    
    
    
    func rotate(sprite:SKSpriteNode, direction:CGPoint)
    {
        sprite.zRotation = CGFloat(atan2(Double(direction.y),Double(direction.x)))
        
    }
    
    
    
    //testing purpose only
    func debugDrawPlayableArea() {
     let shape = SKShapeNode()
     let path = CGMutablePath()
     path.addRect(playableRect)
     shape.path = path
     shape.strokeColor = SKColor.red
     shape.lineWidth = 4.0
     addChild(shape)
    }



    func spawnEnemy()
    {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.position = CGPoint(x:size.width + enemy.size.width/2,
                                 y:size.height/2)
        
        
        addChild(enemy)
        //let actionMove = SKAction.move(to: CGPoint(x:-enemy.size.width,y:enemy.position.y), duration: 2.0)
        
        let actionMidMove = SKAction.move(to: CGPoint(x:size.width/2,
                                                      y:enemy.size.height/2),
                                          duration: 2.0)
        
        let actionMove = SKAction.move(to:CGPoint(x:-enemy.size.width/2,
                                                  y:enemy.position.y),
                                       duration: 2.0)
        
        let wait = SKAction.wait(forDuration: 0.5)
        
        let logMessae = SKAction.run(){
            print("bottom reached. ")
        }
        
        let goCenter = SKAction.move(to: CGPoint(x:size.width/2,
                                                 y: size.height/2), duration: 0.5)
        let goBack = SKAction.move(to: CGPoint(x:size.width/2,
                                               y: 0), duration: 0.5)
        
        //backwards
        
        
        let actionHome = SKAction.move(to: CGPoint(x:size.width + enemy.size.width/2,
        y:size.height/2), duration: 2.0)
        
        let sequence = SKAction.sequence([actionMidMove, logMessae,  wait, goCenter, goBack,  actionMove, wait , actionMidMove,goCenter, goBack,  actionHome])
        enemy.run(SKAction.repeatForever(sequence))
        
    }
}


