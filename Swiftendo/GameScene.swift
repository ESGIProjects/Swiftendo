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
import WatchConnectivity

class GameScene: SKScene {
	
	var cameraNode: SKCameraNode!
	var lastTouch: CGPoint = .zero
	var originalTouch: CGPoint = .zero
	
    //init parameters for music
    var backgroundMusic: AVAudioPlayer?
    var musicNumber = 0
	
    //buttons
	var upButton: ButtonNode!
    var downButton: ButtonNode!
    var leftButton: ButtonNode!
    var rightButton: ButtonNode!
    var startButton: ButtonNode!
    var actionButton: ButtonNode!
	
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
		
		// Add the player into the map
		player = SKShapeNode(rectOf: CGSize(width: 16, height: 16))
		player.position = CGPoint(x: 0, y: 0)
		addChild(player)
		
		setCameraConstraints()
		
		print("Frame size - width: \(frame.width) x height: \(frame.height)")
		
		print("Scene size - width: \(size.width) x height: \(size.height)")
		
		print("Frame mindX: \(frame.minX) maxX: \(frame.maxX)")
		print("Frame minY: \(frame.minY) maxY: \(frame.maxY)")
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
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
    
    func playBackgroundMusic() {
		let selectedMusic = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: musicList).first as! String
		
		if let path = Bundle.main.path(forResource: selectedMusic, ofType: "mp3") {
			let url = URL(fileURLWithPath: path)
			backgroundMusic = try? AVAudioPlayer(contentsOf: url)
			backgroundMusic?.play()
			backgroundMusic?.delegate = self
		}
    }
    
    func initButtons() {
		upButton = ButtonNode(button: .up)
		upButton.action = {[unowned self] in self.touchButton(.up) }
		upButton.anchorPoint = CGPoint(x: 0,y: 0)
        upButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 85)
        upButton.xScale = 0.15
        upButton.yScale = 0.15
		upButton.alpha = 0.5
        cameraNode.addChild(upButton)
		
		downButton = ButtonNode(button: .down)
		downButton.action = {[unowned self] in self.touchButton(.down) }
        downButton.anchorPoint = CGPoint(x: 0,y: 0)
        downButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 25)
        downButton.xScale = 0.15
        downButton.yScale = 0.15
		downButton.alpha = 0.5
        cameraNode.addChild(downButton)
		
		leftButton = ButtonNode(button: .left)
		leftButton.action = {[unowned self] in self.touchButton(.left) }
        leftButton.anchorPoint = CGPoint(x: 0,y: 0)
        leftButton.position = CGPoint(x: frame.minX + 40, y: frame.minY + 57.5)
        leftButton.xScale = 0.15
        leftButton.yScale = 0.15
		leftButton.alpha = 0.5
        cameraNode.addChild(leftButton)
		
		rightButton = ButtonNode(button: .right)
		rightButton.action = {[unowned self] in self.touchButton(.right) }
        rightButton.anchorPoint = CGPoint(x: 0,y: 0)
        rightButton.position = CGPoint(x: frame.minX + 105, y: frame.minY + 57.5)
        rightButton.xScale = 0.15
        rightButton.yScale = 0.15
		rightButton.alpha = 0.5
        cameraNode.addChild(rightButton)
		
		startButton = ButtonNode(button: .start)
		startButton.action = {[unowned self] in self.touchButton(.start) }
        startButton.position = CGPoint(x: 0,y: frame.minY + 30)
        startButton.xScale = 0.6
        startButton.yScale = 0.6
		startButton.alpha = 0.5
        cameraNode.addChild(startButton)
        
        if WCSession.isSupported() {
            let session = WCSession.default
            if !session.isWatchAppInstalled || !session.isReachable{
                session.delegate = self as? WCSessionDelegate
                session.activate()
                actionButton = ButtonNode(button: .action)
                actionButton.action = {[unowned self] in self.touchButton(.action) }
                actionButton.position = CGPoint(x: frame.maxX - 70, y: frame.minY + 72.5)
                actionButton.xScale = 0.6
                actionButton.yScale = 0.6
                actionButton.alpha = 0.5
                cameraNode.addChild(actionButton)
            }
        }
    }
	
	func touchButton(_ button: Button) {
		switch button {
		case .up:
			self.player.run(SKAction.moveBy(x: 0, y: 32, duration: 0.2))
		case .down:
			self.player.run(SKAction.moveBy(x: 0, y: -32, duration: 0.2))
		case .left:
			self.player.run(SKAction.moveBy(x: -32, y: 0, duration: 0.2))
		case .right:
			self.player.run(SKAction.moveBy(x: 32, y: 0, duration: 0.2))
		case .start:
			print("Start button touched")
		case .action:
			print("Action button touched")
		}
		
		print("Player position - x: \(player.position.x) y: \(player.position.y)")
		print("Camera position - x: \(cameraNode.position.x) y: \(cameraNode.position.y)")
		print("")
		
	}
	
	func setCameraConstraints() {
		// Follow the player
		var cameraConstraints = [SKConstraint]()
		
		let playerRange = SKRange(constantValue: 0)
		let playerConstraint = SKConstraint.distance(playerRange, to: player)
		cameraConstraints.append(playerConstraint)
		
		// Edge constraints
		//let sceneWidth: CGFloat = 2400.0
		//let sceneHeight: CGFloat = 1200.0
		
		if let tileMap = childNode(withName: "Tile Map Node") {
			
			/*
			let xRange = SKRange(lowerLimit: frame.minX/4.0, upperLimit: frame.maxX/4.0)
			let yRange = SKRange(lowerLimit: frame.minY, upperLimit: frame.maxY)
			let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
			edgeConstraint.referenceNode = self
			cameraConstraints.append(edgeConstraint)
			*/
			
			let rect = tileMap.calculateAccumulatedFrame()
			print(rect)
			print(rect.origin)
			
			let left = SKConstraint.positionX(SKRange(lowerLimit: cameraNode.position.x))
			let bottom = SKConstraint.positionX(SKRange(lowerLimit: cameraNode.position.y))
			
			let top = SKConstraint.positionX(SKRange(upperLimit: tileMap.frame.size.height - cameraNode.position.y))
			let right = SKConstraint.positionX(SKRange(upperLimit: tileMap.frame.size.width - cameraNode.position.x))
			
			cameraConstraints.append(left)
			cameraConstraints.append(bottom)
			cameraConstraints.append(top)
			cameraConstraints.append(right)
		}
		
		cameraNode.constraints = cameraConstraints
		//cameraNode.constraints = [playerConstraint, edgeConstraint]
		//cameraNode.constraints = [playerConstraint]
	}
}

extension GameScene: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		playBackgroundMusic()
	}
}
