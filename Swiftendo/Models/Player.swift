//
//  Player.swift
//  Swiftendo
//
//  Created by Jason Pierna on 08/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import SpriteKit

class Player {
	
	var node: SKSpriteNode 
	var health: Int
	var direction: Direction
	var speed: Double
	
	init() {
		health = 3
		direction = .down
		speed = 160
		
		node = SKSpriteNode(imageNamed: "link-\(direction.rawValue)")
		node.name = "player"
		node.zPosition = 1
	}
	
	func moveTo(_ direction: Direction) {
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
