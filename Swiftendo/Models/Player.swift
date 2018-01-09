//
//  Player.swift
//  Swiftendo
//
//  Created by Jason Pierna on 08/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
	
	enum Direction: String {
		case up = "up"
		case down = "down"
		case left = "left"
		case right = "right"
	}
	
	init() {
		let texture = SKTexture(imageNamed: "link-down")
		super.init(texture: texture, color: .clear, size: texture.size())
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func moveTo(_ direction: Direction) {
		
		texture = SKTexture(imageNamed: "link-\(direction.rawValue)")
		
		switch direction {
		case .up:
			run(SKAction.moveBy(x: 0, y: 16, duration: 0.1))
		case .down:
			run(SKAction.moveBy(x: 0, y: -16, duration: 0.1))
		case .left:
			run(SKAction.moveBy(x: -16, y: 0, duration: 0.1))
		case .right:
			run(SKAction.moveBy(x: 16, y: 0, duration: 0.1))
		}
	}
}
