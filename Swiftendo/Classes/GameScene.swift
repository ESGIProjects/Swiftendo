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
		"Sounds/Tal_Tal_Mountain_GB",
        "Sounds/Lavanville",
        "Sounds/Mario_Overworld",
        "Sounds/Green_Greens",
        "Sounds/Celadopole",
        "Sounds/Delfino_Plaza",
        "Sounds/Mansion",
        "Sounds/Metroid_Main"
	]
	
	// MARK: - Button properties
	
	var buttons = [String: Button]()
	/*
	var upButton: Button!
    var downButton: Button!
    var leftButton: Button!
    var rightButton: Button!
    var startButton: Button!
    var actionButton: Button!*/
	
	// MARK: - Entity properties
	
	var player: Player!
	var monsters = [Monster]()
	
	// MARK: - Apple Watch session
	var session: WCSession?
	
	// MARK: - SKScene
    
    override func didMove(to view: SKView) {
		// Set properties
		cameraNode = camera!
		tileMapNode = childNode(withName: "Tile Map Node") as! SKTileMapNode
		physicsWorld.contactDelegate = self

		// Start watch session
		startSession()
		
		// Set player property
		player = spawnPlayer()
		addChild(player.node)
		
		// Initialize music & buttons
        playBackgroundMusic()
        initButtons()
		setHearts()
		
		// Constraints the camera
		setCameraConstraints()
		
		// Start enemy spawn 5 seconds later
		self.launchMonsterGeneration(timeInterval: 5)
    }
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
	
	func launchMonsterGeneration(timeInterval: TimeInterval) {
		Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [unowned self] _ in
	
			let monster = self.spawnMonster()
			self.monsters.append(monster)
			self.addChild(monster.node)
			
			monster.followPlayer(self.player)
			
			// create monster
			self.launchMonsterGeneration(timeInterval: max(timeInterval-1, 3))
		}
	}
	
	// MARK: - Helpers
	
    func playBackgroundMusic() {
		let selectedMusic = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: musicList).first as! String
		
		if let path = Bundle.main.path(forResource: selectedMusic, ofType: "mp3") {
			let url = URL(fileURLWithPath: path)
			backgroundMusic = try? AVAudioPlayer(contentsOf: url)
			backgroundMusic?.delegate = self
			backgroundMusic?.play()
		}
    }
	
	func setHearts() {
		while let node = cameraNode.childNode(withName: "heart") {
			node.removeFromParent()
		}
		
		let yOffset = 5.0
		let spacing = 4.0
		
		switch player.health {
		case 1:
			// Centered heart
			let centerHeart = SKSpriteNode(imageNamed: "heart")
			centerHeart.anchorPoint = CGPoint(x: 0.5, y: 1)
			centerHeart.name = "heart"
			centerHeart.position = CGPoint(x: 0, y: frame.maxY - yOffset)
			cameraNode.addChild(centerHeart)
		case 2:
			// Left heart
			let leftHeart = SKSpriteNode(imageNamed: "heart")
			leftHeart.anchorPoint = CGPoint(x: 0.5, y: 1)
			leftHeart.name = "heart"
			leftHeart.position = CGPoint(x: 0 - (spacing + leftHeart.size.width)/2, y: frame.maxY - yOffset)
			cameraNode.addChild(leftHeart)
			
			// Right heart
			let rightHeart = SKSpriteNode(imageNamed: "heart")
			rightHeart.anchorPoint = CGPoint(x: 0.5, y: 1)
			rightHeart.name = "heart"
			rightHeart.position = CGPoint(x: 0 + (spacing + rightHeart.size.width)/2, y: frame.maxY - yOffset)
			cameraNode.addChild(rightHeart)
		case 3:
			// Centered heart
			let centerHeart = SKSpriteNode(imageNamed: "heart")
			centerHeart.anchorPoint = CGPoint(x: 0.5, y: 1)
			centerHeart.name = "heart"
			centerHeart.position = CGPoint(x: 0, y: frame.maxY - yOffset)
			cameraNode.addChild(centerHeart)
			
			print("heart width", centerHeart.size.width)
			
			// Left heart
			let leftHeart = SKSpriteNode(imageNamed: "heart")
			leftHeart.anchorPoint = CGPoint(x: 0.5, y: 1)
			leftHeart.name = "heart"
			leftHeart.position = CGPoint(x: 0 - spacing - leftHeart.size.width, y: frame.maxY - yOffset)
			cameraNode.addChild(leftHeart)
			
			// Right heart
			let rightHeart = SKSpriteNode(imageNamed: "heart")
			rightHeart.anchorPoint = CGPoint(x: 0.5, y: 1)
			rightHeart.name = "heart"
			rightHeart.position = CGPoint(x: 0 + spacing + rightHeart.size.width, y: frame.maxY - yOffset)
			cameraNode.addChild(rightHeart)
		default:
			break
		}
	}
	
    func initButtons() {
		let upButton = Button(type: .up)
		upButton.action = {[unowned self] in self.touchButton(.up) }
		upButton.anchorPoint = CGPoint(x: 0,y: 0)
        upButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 85)
        upButton.xScale = 0.15
        upButton.yScale = 0.15
		upButton.alpha = 0.5
		buttons["up"] = upButton
		cameraNode.addChild(upButton)
		
		let downButton = Button(type: .down)
		downButton.action = {[unowned self] in self.touchButton(.down) }
        downButton.anchorPoint = CGPoint(x: 0,y: 0)
        downButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 25)
        downButton.xScale = 0.15
        downButton.yScale = 0.15
		downButton.alpha = 0.5
		buttons["down"] = downButton
        cameraNode.addChild(downButton)
		
		let leftButton = Button(type: .left)
		leftButton.action = {[unowned self] in self.touchButton(.left) }
        leftButton.anchorPoint = CGPoint(x: 0,y: 0)
        leftButton.position = CGPoint(x: frame.minX + 40, y: frame.minY + 57.5)
        leftButton.xScale = 0.15
        leftButton.yScale = 0.15
		leftButton.alpha = 0.5
		buttons["left"] = leftButton
        cameraNode.addChild(leftButton)
		
		let rightButton = Button(type: .right)
		rightButton.action = {[unowned self] in self.touchButton(.right) }
        rightButton.anchorPoint = CGPoint(x: 0,y: 0)
        rightButton.position = CGPoint(x: frame.minX + 105, y: frame.minY + 57.5)
        rightButton.xScale = 0.15
        rightButton.yScale = 0.15
		rightButton.alpha = 0.5
		buttons["right"] = rightButton
        cameraNode.addChild(rightButton)
		
		let startButton = Button(type: .start)
		startButton.action = {[unowned self] in self.touchButton(.start) }
        startButton.position = CGPoint(x: 0,y: frame.minY + 30)
        startButton.xScale = 0.6
        startButton.yScale = 0.6
		startButton.alpha = 0.5
		buttons["start"] = startButton
        cameraNode.addChild(startButton)

        if !(session?.isReachable)! || !(session?.isPaired)!{
            let actionButton = Button(type: .action)
            actionButton.action = {[unowned self] in self.touchButton(.action) }
            actionButton.position = CGPoint(x: frame.maxX - 70, y: frame.minY + 72.5)
            actionButton.xScale = 0.6
            actionButton.yScale = 0.6
            actionButton.alpha = 0.5
			buttons["action"] = actionButton
            cameraNode.addChild(actionButton)
        }
    }
    
    func startSession(){
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
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
		case .action:
            player.fire()
		}
		
		for monster in monsters {
			monster.followPlayer(player)
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
		let player = Player(scene: self)
		
		player.node.position = CGPoint(x: 0, y: 0)
		
		return player
	}
	
	func spawnMonster() -> Monster {
		let monster = Monster()
        
        let xPosition = (CGFloat(tileMapNode.numberOfColumns) * tileMapNode.tileSize.width)
        let yPosition = (CGFloat(tileMapNode.numberOfRows) * tileMapNode.tileSize.width)
        
        monster.node.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(xPosition))) - (xPosition / 2), y: CGFloat(arc4random_uniform(UInt32(yPosition))) - (yPosition / 2))
        
		return monster
	}
	
	// MARK: - Collisions
	
	func collisionBetween(monster monsterNode: SKNode, player playerNode: SKNode) {
		// Player takes damage
		player.takeDamage()
	}
	
	func collisionBetween(monster monsterNode: SKNode, pokeball: SKNode) {
		guard let monster = findMonster(from: monsterNode) else { return }
		
		// Monster takes damage
		pokeball.removeFromParent()
		monster.takeDamage()
	}
	
	func findMonster(from node: SKNode) -> Monster? {
		for monster in monsters {
			if monster.node == node {
				return monster
			}
		}
		
		return nil
	}
	
	// MARK: - Pause & End game
	
	func gameOver() {
		print("Game over!")
		
		/*
		for monster in monsters {
		monster.node.removeAction(forKey: "follow")
		}
		*/
		
		// Overlay
		let overlay = SKShapeNode(rectOf: size)
		overlay.fillColor = UIColor.black.withAlphaComponent(0.5)
		overlay.position = .zero
		overlay.zPosition = 1 // on top of buttons
		
		// Add game over on overlay
		let gameOverText = SKLabelNode()
		gameOverText.text = "GAME OVER !"
		gameOverText.fontColor = .white
		gameOverText.position = .zero
		overlay.addChild(gameOverText)
		
		// Add overlay
		cameraNode.addChild(overlay)
		
	}
	
	func restart() {
		
	}
	
	func pause() {
		
	}
	
	func resume() {
		
	}
	
}

// MARK: - AVAudioPlayerDelegate
extension GameScene: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		playBackgroundMusic()
	}
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		if contact.bodyA.node?.name == "monster" {
			if contact.bodyB.node?.name == "player" {
				print("Player collision")
				collisionBetween(monster: contact.bodyA.node!, player: contact.bodyB.node!)
			} else if contact.bodyB.node?.name == "pokeball" {
				print("Pokeball collision")
				collisionBetween(monster: contact.bodyA.node!, pokeball: contact.bodyB.node!)
			}
		} else if contact.bodyB.node?.name == "monster" {
			if contact.bodyA.node?.name == "player" {
				print("Player collision")
				collisionBetween(monster: contact.bodyB.node!, player: contact.bodyA.node!)
			} else if contact.bodyA.node?.name == "pokeball" {
				print("Pokeball collision")
				collisionBetween(monster: contact.bodyB.node!, pokeball: contact.bodyA.node!)
			}
		}
	}
}

// MARK: - WCSessionDelegate
extension GameScene: WCSessionDelegate{
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        touchButton(.action)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
