//
//  SKNode+Action.swift
//  Swiftendo
//
//  Created by Jason Pierna on 13/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import SpriteKit

extension SKNode {
	func run(_ action: SKAction, withKey key: String, completion block: @escaping () -> Void) {
		run(SKAction.sequence([action, SKAction.run(block)]), withKey: key)
	}
}
