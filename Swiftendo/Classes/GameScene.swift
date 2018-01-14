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
	
	// MARK: - SpriteKit properties
	
	var cameraNode: SKCameraNode!
	var tileMapNode: SKTileMapNode!
	
	// MARK: - Touch properties
	
	var lastTouch: CGPoint = .zero
	var originalTouch: CGPoint = .zero
	
	// MARK: - Music properties
	
    var backgroundMusic: AVAudioPlayer?
    var musicNumber = 0
	
	let musicList = [
		"Sounds/Hyrule_Castle_SNES",
		"Sounds/Hyrule_Field_SNES",
		"Sounds/Dark_World_SNES",
		"Sounds/Hyrule_Field_Wii",
		"Sounds/Lost_Woods_N64",
		"Sounds/Gerudo_Valley_N64",
		"Sounds/Tal_Tal_Mountain_GB"
	]
	
	// MARK: - Button properties
	
	var upButton: Button!
    var downButton: Button!
    var leftButton: Button!
    var rightButton: Button!
    var startButton: Button!
    var actionButton: Button!
	
	// MARK: - Entity properties
	
	var player: Player!
	var monsters = [Monster]()
	
	// MARK: - SKScene
    
    override func didMove(to view: SKView) {
		// Set properties
		cameraNode = camera!
		tileMapNode = childNode(withName: "Tile Map Node") as! SKTileMapNode
		
		// Set player property
		//entityManager.spawnPlayer()
		//guard let player = entityManager.player else { return }
		player = spawnPlayer()
		addChild(player.node)
		
		// Initialize music & buttons
        //playBackgroundMusic()
        initButtons()
		
		// Constraints the camera
		setCameraConstraints()
		
		// Start enemy spawn 5 seconds later
		Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [unowned self] _ in
			self.launchMonsterGeneration(timeInterval: 2)
		}
    }
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
		let playerPosition = CGPoint(x: Int(round(self.player.node.position.x/16)), y: Int(round(self.player.node.position.y/16)))
		
		for monster in self.monsters {
			//monster.node.removeAction(forKey: "path")
			let monsterPosition = CGPoint(x: Int(round(monster.node.position.x/16)), y: Int(round(monster.node.position.y/16)))
			
			DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
				let path = self.tileMapNode.path(from: monsterPosition, to: playerPosition)
				DispatchQueue.main.async {
					monster.followPath(path)
				}
			}
		}
	}
	
	func launchMonsterGeneration(timeInterval: TimeInterval) {
		Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [unowned self] _ in
	
			print("Launch monster generation called with timeInterval of \(timeInterval)")
			let monster = self.spawnMonster()
			self.monsters.append(monster)
			self.addChild(monster.node)
			
			// create monster
			//self.launchMonsterGeneration(timeInterval: timeInterval)
		}
	}
	
	// MARK: - Helpers
	
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
		upButton = Button(type: .up)
		upButton.action = {[unowned self] in self.touchButton(.up) }
		upButton.anchorPoint = CGPoint(x: 0,y: 0)
        upButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 85)
        upButton.xScale = 0.15
        upButton.yScale = 0.15
		upButton.alpha = 0.5
        cameraNode.addChild(upButton)
		
		downButton = Button(type: .down)
		downButton.action = {[unowned self] in self.touchButton(.down) }
        downButton.anchorPoint = CGPoint(x: 0,y: 0)
        downButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 25)
        downButton.xScale = 0.15
        downButton.yScale = 0.15
		downButton.alpha = 0.5
        cameraNode.addChild(downButton)
		
		leftButton = Button(type: .left)
		leftButton.action = {[unowned self] in self.touchButton(.left) }
        leftButton.anchorPoint = CGPoint(x: 0,y: 0)
        leftButton.position = CGPoint(x: frame.minX + 40, y: frame.minY + 57.5)
        leftButton.xScale = 0.15
        leftButton.yScale = 0.15
		leftButton.alpha = 0.5
        cameraNode.addChild(leftButton)
		
		rightButton = Button(type: .right)
		rightButton.action = {[unowned self] in self.touchButton(.right) }
        rightButton.anchorPoint = CGPoint(x: 0,y: 0)
        rightButton.position = CGPoint(x: frame.minX + 105, y: frame.minY + 57.5)
        rightButton.xScale = 0.15
        rightButton.yScale = 0.15
		rightButton.alpha = 0.5
        cameraNode.addChild(rightButton)
		
		startButton = Button(type: .start)
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
                actionButton = Button(type: .action)
                actionButton.action = {[unowned self] in self.touchButton(.action) }
                actionButton.position = CGPoint(x: frame.maxX - 70, y: frame.minY + 72.5)
                actionButton.xScale = 0.6
                actionButton.yScale = 0.6
                actionButton.alpha = 0.5
                cameraNode.addChild(actionButton)
            }
        }
    }
	
	func touchButton(_ button: ButtonType) {
		switch button {
		case .up:
			player.moveTo(.up)
		case .down:
			player.moveTo(.down)
		case .left:
			player.moveTo(.left)
		case .right:
			player.moveTo(.right)
		case .start:
			print("Start button touched")
			
			let start = CGPoint(x: Int(round(player.node.position.x)/16), y: Int(round(player.node.position.y)/16))
			let end = CGPoint(x: start.x + 5, y: start.y)
			
			let actions = tileMapNode.path(from: start, to: end)
			let sequence = SKAction.sequence(actions)
			
			player.node.run(sequence, withKey: "move") { [unowned self] in
				print("(After sequence) Player position - x: \(self.player.node.position.x) y: \(self.player.node.position.y)")
			}
		case .action:
			print("Action button touched")
		}
		

		
		
	}
	
	func setCameraConstraints() {
		guard let camera = camera else { return }
		
		let zeroRange = SKRange(constantValue: 0.0)
		let playerLocationConstraint = SKConstraint.distance(zeroRange, to: player.node)
		
		let scaledSize = CGSize(width: size.width * camera.xScale, height: size.height * camera.yScale)
		
		let accumulatedFrame = calculateAccumulatedFrame()
		
		let xInset = min(scaledSize.width / 2, accumulatedFrame.width / 2)
		let yInset = min(scaledSize.height / 2, accumulatedFrame.height / 2)
		
		let insetContentRect = accumulatedFrame.insetBy(dx: xInset, dy: yInset)
		
		let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
		let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
		
		let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
		levelEdgeConstraint.referenceNode = self
		
		camera.constraints = [playerLocationConstraint, levelEdgeConstraint]
	}
	
	// MARK: - Create new entity
	
	func spawnPlayer() -> Player{
		let player = Player()
		
		
		player.node.position = CGPoint(x: 0, y: 0)

		player.node.zPosition = 0
		
		//add(player)
		return player
	}
	
	func spawnMonster() -> Monster {
		let monster = Monster()
		
		
		// 1. get GKGrid
		// 2. select random tile
		
		
		monster.node.position = CGPoint(x: 0, y: 0)
		monster.node.zPosition = 0
		
		return monster
		
		
		//add(monster)
	}
	
	
	
	
}

// MARK: - AVAudioPlayerDelegate
extension GameScene: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		playBackgroundMusic()
	}
}
