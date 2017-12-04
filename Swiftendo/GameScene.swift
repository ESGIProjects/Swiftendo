//
//  GameScene.swift
//  Swiftendo
//
//  Created by Kévin Le on 20/11/2017.
//  Copyright © 2017 ESGI. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, AVAudioPlayerDelegate {
	
	var cameraNode: SKCameraNode!
	var lastTouch: CGPoint = .zero
	var originalTouch: CGPoint = .zero
	
    //init parameters for music
    var backgroundMusic: AVAudioPlayer!
    var musicNumber: Int = 0
    var path : String!
    
    //buttons
    let upButton = SKSpriteNode(imageNamed: "Button_up")
    let downButton = SKSpriteNode(imageNamed: "Button_down")
    let leftButton = SKSpriteNode(imageNamed: "Button_left")
    let rightButton = SKSpriteNode(imageNamed: "Button_right")
    let startButton = SKSpriteNode(imageNamed: "Start")
    let actionButton = SKSpriteNode(imageNamed: "A")
    
    let musicList = ["Sounds/Hyrule_Castle_SNES.mp3","Sounds/Hyrule_Field_SNES.mp3","Sounds/Dark_World_SNES.mp3",
                     "Sounds/Hyrule_Field_Wii.mp3","Sounds/Lost_Woods_N64.mp3","Sounds/Gerudo_Valley_N64",
                     "Sounds/Tal_Tal_Mountain_GB.mp3"]
    
    override func didMove(to view: SKView) {
		cameraNode = camera!
		
        playBackgroundMusic()
        initButtons()
    }
    
    func playBackgroundMusic() {
        
        musicNumber = Int(arc4random_uniform(UInt32(musicList.count)))
        
        let path = Bundle.main.path(forResource: musicList[musicNumber], ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do{
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic.play()
            backgroundMusic.delegate = self as AVAudioPlayerDelegate
        }
        catch{
            print("Can't load the music !")
        }
    }
    
    func initButtons(){
        
        let sizes = self.frame
        
        upButton.anchorPoint = CGPoint(x:0,y:0)
        upButton.position = CGPoint(x:sizes.minX+75,y:sizes.minY+85)
        upButton.xScale = 0.15
        upButton.yScale = 0.15
        cameraNode.addChild(upButton)
        
        downButton.anchorPoint = CGPoint(x:0,y:0)
        downButton.position = CGPoint(x:sizes.minX+75,y:sizes.minY+25)
        downButton.xScale = 0.15
        downButton.yScale = 0.15
        cameraNode.addChild(downButton)
        
        leftButton.anchorPoint = CGPoint(x:0,y:0)
        leftButton.position = CGPoint(x:sizes.minX+40,y:sizes.minY+57.5)
        leftButton.xScale = 0.15
        leftButton.yScale = 0.15
        cameraNode.addChild(leftButton)
        
        rightButton.anchorPoint = CGPoint(x:0,y:0)
        rightButton.position = CGPoint(x:sizes.minX+105,y:sizes.minY+57.5)
        rightButton.xScale = 0.15
        rightButton.yScale = 0.15
        cameraNode.addChild(rightButton)
        
        startButton.position = CGPoint(x:0,y:sizes.minY+30)
        startButton.xScale = 0.6
        startButton.yScale = 0.6
        cameraNode.addChild(startButton)
        
        actionButton.position = CGPoint(x:sizes.maxX-70,y:sizes.minY+72.5)
        actionButton.xScale = 0.6
        actionButton.yScale = 0.6
        cameraNode.addChild(actionButton)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBackgroundMusic()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		lastTouch = touch.location(in: self.view)
		originalTouch = lastTouch
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let touchLocation = touch.location(in: self.view)
		
		let newX = cameraNode.position.x + (lastTouch.x - touchLocation.x)
		let newY = cameraNode.position.y + (touchLocation.y - lastTouch.y)
		
		cameraNode.position = CGPoint(x: newX, y: newY)
		lastTouch = touchLocation
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}
