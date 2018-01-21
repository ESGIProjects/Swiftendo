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
	
	private var timer: Timer!
	
	// MARK: - SpriteKit properties
	private var cameraNode: SKCameraNode!
	var tileMapNode: SKTileMapNode!
	
	// MARK: - Music properties
	
    private var backgroundMusic: AVAudioPlayer?
    private var musicNumber = 0
	
	private let musicList = [
		"Sounds/Themes/Hyrule_Castle_SNES",
		"Sounds/Themes/Hyrule_Field_SNES",
		"Sounds/Themes/Dark_World_SNES",
		"Sounds/Themes/Hyrule_Field_Wii",
		"Sounds/Themes/Lost_Woods_N64",
		"Sounds/Themes/Gerudo_Valley_N64",
		"Sounds/Themes/Tal_Tal_Mountain_GB",
        "Sounds/Themes/Lavanville",
        "Sounds/Themes/Mario_Overworld",
        "Sounds/Themes/Green_Greens",
        "Sounds/Themes/Celadopole",
        "Sounds/Themes/Delfino_Plaza",
        "Sounds/Themes/Mansion",
        "Sounds/Themes/Metroid_Main"
	]
	
	// MARK: - Button properties
	
	private var buttons = [String: Button]()
	
	// MARK: - Entity properties
	
	private var player: Player!
	private var monsters = [Monster]()
	
	// MARK: - Apple Watch session
	private var session: WCSession?
	
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
        //playBackgroundMusic()
        initButtons()
		setHearts()
		
		// Constraints the camera
		setCameraConstraints()
		
		// Start enemy spawn 5 seconds later
		timer = launchMonsterGeneration(timeInterval: 5)
    }
	
	private func launchMonsterGeneration(timeInterval: TimeInterval) -> Timer {
		return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [unowned self] _ in
	
			let monster = self.spawnMonster()
			self.monsters.append(monster)
			self.addChild(monster.node)
			
			monster.followPlayer(self.player)
		}
	}
	
	// MARK: - Helpers
	
    private func playBackgroundMusic() {
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
	
    private func initButtons() {
		let upButton = Button(type: .up)
		upButton.action = {[unowned self] in self.touchButton(.up) }
		upButton.anchorPoint = .zero
        upButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 85)
        upButton.xScale = 0.15
        upButton.yScale = 0.15
		upButton.alpha = 0.5
		buttons["up"] = upButton
		cameraNode.addChild(upButton)
		
		let downButton = Button(type: .down)
		downButton.action = {[unowned self] in self.touchButton(.down) }
        downButton.anchorPoint = .zero
        downButton.position = CGPoint(x: frame.minX + 75, y: frame.minY + 25)
        downButton.xScale = 0.15
        downButton.yScale = 0.15
		downButton.alpha = 0.5
		buttons["down"] = downButton
        cameraNode.addChild(downButton)
		
		let leftButton = Button(type: .left)
		leftButton.action = {[unowned self] in self.touchButton(.left) }
        leftButton.anchorPoint = .zero
        leftButton.position = CGPoint(x: frame.minX + 40, y: frame.minY + 57.5)
        leftButton.xScale = 0.15
        leftButton.yScale = 0.15
		leftButton.alpha = 0.5
		buttons["left"] = leftButton
        cameraNode.addChild(leftButton)
		
		let rightButton = Button(type: .right)
		rightButton.action = {[unowned self] in self.touchButton(.right) }
        rightButton.anchorPoint = .zero
        rightButton.position = CGPoint(x: frame.minX + 105, y: frame.minY + 57.5)
        rightButton.xScale = 0.15
        rightButton.yScale = 0.15
		rightButton.alpha = 0.5
		buttons["right"] = rightButton
        cameraNode.addChild(rightButton)
		
		let actionButton = Button(type: .action)
		actionButton.action = {[unowned self] in self.touchButton(.action) }
		actionButton.position = CGPoint(x: frame.maxX - 70, y: frame.minY + 72.5)
		actionButton.xScale = 0.6
		actionButton.yScale = 0.6
		actionButton.alpha = 0.5
		buttons["action"] = actionButton
		
		displayActionButton()
    }
    
    private func startSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
	
	private func touchButton(_ button: ButtonType) {
		switch button {
		case .up:
			player.moveTo(.up)
		case .down:
			player.moveTo(.down)
		case .left:
			player.moveTo(.left)
		case .right:
			player.moveTo(.right)
		case .action:
            player.fire()
		}
		
		for monster in monsters {
			monster.followPlayer(player)
		}
	}
	
	private func setCameraConstraints() {
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
	
	private func spawnPlayer() -> Player{
		let player = Player(scene: self)
		
		player.node.position = CGPoint(x: 0, y: 0)
		
		return player
	}
	
	private func spawnMonster() -> Monster {
		let monster = Monster()
        
        let xPosition = (CGFloat(tileMapNode.numberOfColumns) * tileMapNode.tileSize.width)
        let yPosition = (CGFloat(tileMapNode.numberOfRows) * tileMapNode.tileSize.width)
        
        monster.node.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(xPosition))) - (xPosition / 2), y: CGFloat(arc4random_uniform(UInt32(yPosition))) - (yPosition / 2))
        
		return monster
	}
	
	// MARK: - Collisions
	
	private func collisionBetween(monster monsterNode: SKNode, player playerNode: SKNode) {
		// Player takes damage
		player.takeDamage()
	}
	
	private func collisionBetween(monster monsterNode: SKNode, pokeball: SKNode) {
		guard let monster = findMonster(from: monsterNode) else { return }
		
		// Monster takes damage
		pokeball.removeFromParent()
		monster.takeDamage()
	}
	
	private func findMonster(from node: SKNode) -> Monster? {
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
		
		timer.invalidate()
		
		for monster in monsters {
			monster.node.removeAction(forKey: "follow")
		}
		
		// Overlay
		let overlay = SKShapeNode(rectOf: frame.size)
		overlay.name = "overlay"
		overlay.fillColor = UIColor.black.withAlphaComponent(0.5)
		overlay.position = .zero
		overlay.zPosition = 1 // on top of buttons
		
		// Add game over on overlay
		let gameOverText = SKLabelNode(fontNamed: "Chalkduster")
		
		let attributedText = NSAttributedString(string: "GAME OVER", attributes: [
			.font: UIFont.boldSystemFont(ofSize: 64),
			.foregroundColor: UIColor.white
		])
		
		gameOverText.attributedText = attributedText
		gameOverText.fontColor = .white
		gameOverText.position = CGPoint(x: 0, y: 50)
		overlay.addChild(gameOverText)
		
		// Add retry button
		let retry = RetryButton(scene: self)
		retry.position = CGPoint(x: 0, y: -50)
		retry.xScale = 0.5
		retry.yScale = 0.5
		overlay.addChild(retry)
		
		// Add overlay
		cameraNode.addChild(overlay)
	}
	
	func restart() {
		
		// Remove monsters
		for monster in monsters {
			monster.node.removeFromParent()
		}
		monsters.removeAll()
		
		// Reset the player position
		player.reset(at: .zero)
		
		// Display health
		setHearts()
		
		// Delete overlay
		if let overlay = cameraNode.childNode(withName: "overlay") {
			overlay.removeFromParent()
		}
		
		// Resume timer
		timer = launchMonsterGeneration(timeInterval: 5)
	}
	
	private func displayActionButton() {
		guard let actionButton = buttons["action"] else { return }
		
		if let session = session {
			if !session.isReachable {
				cameraNode.addChild(actionButton)
			}  else {
				actionButton.removeFromParent()
			}
		} else {
			cameraNode.addChild(actionButton)
		}
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
extension GameScene: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		if let action = message["action"] as? String {
			if action == "action" {
				touchButton(.action)
			}
		}
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
	
	func sessionReachabilityDidChange(_ session: WCSession) {
		displayActionButton()
	}
}
