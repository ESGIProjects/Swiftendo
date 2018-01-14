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
	var health: Int
	var speed: Double
	
	init() {
		health = 1
		speed = 50
		
		node = SKSpriteNode(imageNamed: "metroid")
		node.name = "monster"
	}
	
	func followPlayer(_ player: Player) {
		let playerPosition = player.node.position
		let monsterPosition = node.position
		
		let distance = Double(hypotf(Float(monsterPosition.x - playerPosition.x), Float(monsterPosition.y - playerPosition.y)))
		
		let duration = distance / speed
		
		// If path is changed mid-way, it will be deleted because the new action will have the same key
		node.run(SKAction.move(to: playerPosition, duration: duration), withKey: "follow")
	}
}
