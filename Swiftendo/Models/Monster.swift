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
	
	init() {
		node = SKSpriteNode(imageNamed: "metroid")
		node.name = "monster"
		health = 1
	}
	
	func moveTo(_ direction: Direction) {
		node.run(Player.moveTo(direction, duration: 0.1, sprite: "link"))
	}
	
	func followPlayer(_ player: Player) {
		let playerPosition = player.node.position
		let monsterPosition = node.position
		
		let distance = hypotf(Float(monsterPosition.x - playerPosition.x), Float(monsterPosition.y - playerPosition.y))
		
		print(distance)
		
		// If path is changed mid-way, it will be deleted because the new action will have the same key
		node.run(SKAction.move(to: playerPosition, duration: 1))
	}
}
