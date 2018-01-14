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
	var speed: Double
	
	init(at position: CGPoint) {
		speed = 100
		
		node = SKSpriteNode(imageNamed: "pokeball")
		node.position = position
		node.name = "pokeball"
	}
	
	func fire(in: Direction) {
		
	}
}
