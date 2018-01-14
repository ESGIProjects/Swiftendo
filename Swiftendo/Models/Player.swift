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
	var spriteDirection = Direction.down
	
	init() {
		node = SKSpriteNode(imageNamed: "link-down")
		node.name = "player"
		node.zPosition = 1
		health = 3
	}
	
	static func moveTo(_ direction: Direction, duration: TimeInterval, sprite: String) -> SKAction {
		let changeDirection = SKAction.setTexture(SKTexture(imageNamed:"\(sprite)-\(direction.rawValue)"))
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
		
		return SKAction.group([changeDirection, move])
	}
	
	func moveTo(_ direction: Direction) {
		node.run(Player.moveTo(direction, duration: 0.1, sprite: "link")) { [unowned self] in 
			print("(At touch) Player position - x: \(self.node.position.x) y: \(self.node.position.y)")
		}
        spriteDirection = direction
	}
}
