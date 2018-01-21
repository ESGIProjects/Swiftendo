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
	private var reach: CGFloat
	private var speed: Double
	
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
		var move: SKAction!
		let duration = Double(reach) / speed

		// Move
		
		switch direction {
		case .up:
			move = SKAction.moveBy(x: 0, y: reach, duration: duration)
		case .down:
			move = SKAction.moveBy(x: 0, y: -reach, duration: duration)
		case .left:
			move = SKAction.moveBy(x: -reach, y: 0, duration: duration)
		case .right:
			move = SKAction.moveBy(x: reach, y: 0, duration: duration)
		}
		
		let moveSequence = SKAction.sequence([move, SKAction.removeFromParent()])
		
		// Rotate
		
		let rotate = SKAction.repeatForever(SKAction.rotate(byAngle: 2 * .pi, duration: 0.5))
		
		// Sound
		
		let soundNode = SKAudioNode(fileNamed: "Sounds/Effects/LTTP_Arrow_Shoot.wav")
		soundNode.autoplayLooped = false
		node.addChild(soundNode)
		
		let sound = SKAction.run {
			soundNode.run(SKAction.sequence([SKAction.play()]))//, SKAction.removeFromParent()]))
		}
		
		node.run(SKAction.group([moveSequence, sound, rotate]))

	}
}
