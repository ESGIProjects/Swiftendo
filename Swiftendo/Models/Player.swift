//
//  Player.swift
//  Swiftendo
//
//  Created by Jason Pierna on 08/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import SpriteKit

class Player {
	
	private var scene: GameScene!
	
	var node: SKSpriteNode 
	var health: Int
	var direction: Direction
	private var speed: Double
	
	private var lastTimeHit = TimeInterval(0)
	
	init(scene: GameScene) {
		self.scene = scene
		
		health = 3
		direction = .down
		speed = 160
		
		node = SKSpriteNode(imageNamed: "link-\(direction.rawValue)")
		node.name = "player"
		node.zPosition = 1
		
		node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
		node.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
		node.physicsBody?.contactTestBitMask = CollisionTypes.monster.rawValue
		node.physicsBody?.collisionBitMask = 0
	}
	
	func moveTo(_ direction: Direction) {
		
		if health > 0 {
			
			self.direction = direction
			let changeDirection = SKAction.setTexture(SKTexture(imageNamed:"link-\(direction.rawValue)"))
			
			let duration = 16 / speed
			var move: SKAction!
			
			switch direction {
			case .up:
				move = SKAction.moveBy(x: 0, y: 16, duration: duration)
			case .down:
				move = SKAction.moveBy(x: 0, y: -16, duration: duration)
			case .left:
				move = SKAction.moveBy(x: -16, y: 0, duration: duration)
			case .right:
				move = SKAction.moveBy(x: 16, y: 0, duration: duration)
			}
			
			node.run(SKAction.group([changeDirection, move])) { [unowned self] in
				print("(After move) Player position - x: \(self.node.position.x) y: \(self.node.position.y)")
			}
		}
	}
	
	func fire() {
		if health > 0 {
			
			guard let scene = node.parent else { return }
			
			let pokeball = Pokeball(at: node.position)
			scene.addChild(pokeball.node)
			
			pokeball.fire(in: direction)
		}
	}
	
	func takeDamage() {
		
		if CACurrentMediaTime() - lastTimeHit > TimeInterval(3) {
			lastTimeHit = CACurrentMediaTime()
			health = health - 1
			
			let blinkSequence = SKAction.sequence([
				SKAction.fadeAlpha(to: 0.3, duration: 0.5),
				SKAction.fadeIn(withDuration: 0.5),
				SKAction.fadeAlpha(to: 0.3, duration: 0.5),
				SKAction.fadeIn(withDuration: 0.5),
				SKAction.fadeAlpha(to: 0.3, duration: 0.5)
				])
			
			var action: SKAction!
			
			if health > 0 {
				action = SKAction.sequence([blinkSequence, SKAction.fadeIn(withDuration: 0.5)])
			} else {
				action = SKAction.sequence([blinkSequence, SKAction.run { [unowned self] in self.scene.gameOver() }])
			}
			
			node.run(action)
			scene.setHearts()
		}
	}
	
	func reset(at position: CGPoint) {
		node.position = position
		node.texture = SKTexture(imageNamed: "link-down")
		node.alpha = 1
		health = 3
		direction = .down
	}
}
