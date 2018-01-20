//
//  Pokeball.swift
//  Swiftendo
//
//  Created by Jason Pierna on 14/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import SpriteKit

class Pokeball {
	
	var node: SKSpriteNode
	var reach: CGFloat
	var speed: Double
	
	init(at position: CGPoint) {
		reach = 200
		speed = 320
		
		node = SKSpriteNode(imageNamed: "pokeball")
		node.name = "pokeball"
		node.position = position
		node.zPosition = 2
		
		node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
		node.physicsBody?.categoryBitMask = CollisionTypes.pokeball.rawValue
		node.physicsBody?.contactTestBitMask = CollisionTypes.monster.rawValue
		node.physicsBody?.collisionBitMask = 0
	}
	
	func fire(in direction: Direction) {
		var action: SKAction!
		
		let duration = Double(reach) / speed

		switch direction {
		case .up:
			action = SKAction.moveBy(x: 0, y: reach, duration: duration)
		case .down:
			action = SKAction.moveBy(x: 0, y: -reach, duration: duration)
		case .left:
			action = SKAction.moveBy(x: -reach, y: 0, duration: duration)
		case .right:
			action = SKAction.moveBy(x: reach, y: 0, duration: duration)
		}
		
		node.run(SKAction.sequence([action, SKAction.removeFromParent()]))

	}
}
