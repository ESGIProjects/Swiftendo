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

class GameScene: SKScene {
	
	var cameraNode: SKCameraNode!
	var lastTouch: CGPoint = .zero
	var originalTouch: CGPoint = .zero
	
    //init parameters for music
    var backgroundMusic: AVAudioPlayer?
    var musicNumber = 0
	
    //buttons
	var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var startButton: SKSpriteNode!
    var actionButton: SKSpriteNode!
	
	var player: SKNode!
    
    let musicList = [
		"Sounds/Hyrule_Castle_SNES",
		"Sounds/Hyrule_Field_SNES",
		"Sounds/Dark_World_SNES",
		"Sounds/Hyrule_Field_Wii",
		"Sounds/Lost_Woods_N64",
		"Sounds/Gerudo_Valley_N64",
		"Sounds/Tal_Tal_Mountain_GB"
	]
    
    override func didMove(to view: SKView) {
		cameraNode = camera!
		
        playBackgroundMusic()
        initButtons()
		
		player = SKShapeNode(rectOf: CGSize(width: 16, height: 16))
		player.position = CGPoint(x: 0.5, y: 0.5)
		addChild(player)
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		lastTouch = touch.location(in: view)
		originalTouch = lastTouch
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let touchLocation = touch.location(in: view)
		
		let newX = cameraNode.position.x + (lastTouch.x - touchLocation.x)
		let newY = cameraNode.position.y + (touchLocation.y - lastTouch.y)
		
		cameraNode.position = CGPoint(x: newX, y: newY)
		lastTouch = touchLocation
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		let tappedNodes = nodes(at: touch.location(in: cameraNode))
		
		if let node = tappedNodes.first {
            if node.name == "button" {
                print("Button touched")
			} else {
				print("Random touch")
			}
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
    
    func playBackgroundMusic() {
		let selectedMusic = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: musicList).first as! String
		
		if let path = Bundle.main.path(forResource: selectedMusic, ofType: "mp3") {
			let url = URL(fileURLWithPath: path)
			backgroundMusic = try? AVAudioPlayer(contentsOf: url)
			//backgroundMusic?.play()
			backgroundMusic?.delegate = self
		}
    }
    
    func initButtons() {
		upButton = SKSpriteNode(imageNamed: "Button_up")
		upButton.anchorPoint = CGPoint(x:0,y:0)
        upButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 85)
        upButton.xScale = 0.15
        upButton.yScale = 0.15
		upButton.alpha = 0.5
        upButton.name = "button"
        cameraNode.addChild(upButton)
		
		downButton = SKSpriteNode(imageNamed: "Button_down")
        downButton.anchorPoint = CGPoint(x:0,y:0)
        downButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 25)
        downButton.xScale = 0.15
        downButton.yScale = 0.15
		downButton.alpha = 0.5
        downButton.name = "button"
        cameraNode.addChild(downButton)
		
		leftButton = SKSpriteNode(imageNamed: "Button_left")
        leftButton.anchorPoint = CGPoint(x:0,y:0)
        leftButton.position = CGPoint(x: frame.minX + 40, y: frame.minY + 57.5)
        leftButton.xScale = 0.15
        leftButton.yScale = 0.15
		leftButton.alpha = 0.5
        leftButton.name = "button"
        cameraNode.addChild(leftButton)
		
		rightButton = SKSpriteNode(imageNamed: "Button_right")
        rightButton.anchorPoint = CGPoint(x:0,y:0)
        rightButton.position = CGPoint(x: frame.minX + 105, y: frame.minY + 57.5)
        rightButton.xScale = 0.15
        rightButton.yScale = 0.15
		rightButton.alpha = 0.5
        rightButton.name = "button"
        cameraNode.addChild(rightButton)
		
		startButton = SKSpriteNode(imageNamed: "Start")
        startButton.position = CGPoint(x: 0,y: frame.minY + 30)
        startButton.xScale = 0.6
        startButton.yScale = 0.6
		startButton.alpha = 0.5
        startButton.name = "button"
        cameraNode.addChild(startButton)
		
		actionButton = SKSpriteNode(imageNamed: "A")
        actionButton.position = CGPoint(x: frame.maxX - 70, y: frame.minY + 72.5)
        actionButton.xScale = 0.6
        actionButton.yScale = 0.6
		actionButton.alpha = 0.5
        actionButton.name = "button"
        cameraNode.addChild(actionButton)
    }
}

extension GameScene: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		playBackgroundMusic()
	}
}
