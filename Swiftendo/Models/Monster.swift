//
//  Monster.swift
//  Swiftendo
//
//  Created by Jason Pierna on 11/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Monster {
	
	var node: SKSpriteNode
	private var health: Int
	private var speed: Double
	
	init() {
		health = 1
		speed = 45
		
		if GKRandomSource.sharedRandom().nextBool() {
			node = SKSpriteNode(imageNamed: "metroid")
			node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
		} else {
			node = SKSpriteNode(imageNamed: "boo")
			// weird bug with boo texture
			node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.height/2, center: CGPoint(x: 0.5, y: 0.5))
		}
		
		node.name = "monster"
		node.zPosition = 1
		
		node.physicsBody?.allowsRotation = false
		
		node.physicsBody?.categoryBitMask = CollisionTypes.monster.rawValue
		node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue | CollisionTypes.pokeball.rawValue
		node.physicsBody?.collisionBitMask = 0
	}
	
	func followPlayer(_ player: Player) {
		
		if health > 0 {
			let playerPosition = player.node.position
			let monsterPosition = node.position
			
			let distance = Double(hypotf(Float(monsterPosition.x - playerPosition.x), Float(monsterPosition.y - playerPosition.y)))
			
			let duration = distance / speed
			
			// If path is changed mid-way, it will be deleted because the new action will have the same key
			node.run(SKAction.move(to: playerPosition, duration: duration), withKey: "follow")
		}
	}
	
	func takeDamage() {
		health = health - 1
		
		let blinkSequence = SKAction.sequence([
			SKAction.fadeOut(withDuration: 0.2),
			SKAction.fadeIn(withDuration: 0.2),
			SKAction.fadeOut(withDuration: 0.2)
		])
		
		var action: SKAction!
		
		if health > 0 {
			action = SKAction.sequence([blinkSequence, SKAction.fadeIn(withDuration: 0.1)])
		} else {
			node.removeAction(forKey: "follow")
			node.physicsBody?.categoryBitMask = 0
			node.physicsBody?.contactTestBitMask = 0
			let sequence = SKAction.sequence([blinkSequence, SKAction.removeFromParent()])
			
			let soundNode = SKAudioNode(fileNamed: "Sounds/Effects/LTTP_Enemy_Kill.wav")
			soundNode.autoplayLooped = false
			node.addChild(soundNode)
			
			let sound = SKAction.run {
				soundNode.run(SKAction.play())
			}
			
			action = SKAction.group([sequence, sound])
		}
		
		node.run(action)
	}
}
