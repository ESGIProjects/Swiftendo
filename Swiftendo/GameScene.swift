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
        playBackgroundMusic()
        initButtons()
		
		cameraNode = camera!
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
        
        let size = self.frame
        
        upButton.position = CGPoint(x:0,y:0)
        upButton.xScale = 0.2
        upButton.yScale = 0.2
        self.addChild(upButton)
        
        downButton.position = CGPoint(x:(size.height/2),y:(size.width/2))
        downButton.xScale = 0.1
        downButton.yScale = 0.1
        self.addChild(downButton)
        
        leftButton.position = CGPoint(x:0,y:0)
        leftButton.xScale = 0.2
        leftButton.yScale = 0.2
        self.addChild(leftButton)
        
        rightButton.position = CGPoint(x:0,y:0)
        rightButton.xScale = 0.2
        rightButton.yScale = 0.2
        self.addChild(rightButton)
        
        startButton.position = CGPoint(x:0,y:0)
        startButton.xScale = 0.2
        startButton.yScale = 0.2
        self.addChild(startButton)
        
        actionButton.position = CGPoint(x:0,y:0)
        actionButton.xScale = 0.2
        actionButton.yScale = 0.2
        self.addChild(actionButton)
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
