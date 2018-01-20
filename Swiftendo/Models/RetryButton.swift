//
//  RetryButton.swift
//  Swiftendo
//
//  Created by Jason Pierna on 20/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import SpriteKit

class RetryButton: SKSpriteNode {
	
	let gameScene: GameScene!
	
	init(scene: GameScene) {
		gameScene = scene
		
		let texture = SKTexture(imageNamed: "retry")
		super.init(texture: texture, color: .clear, size: texture.size())
		
		name = "retry"
		isUserInteractionEnabled = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		gameScene.restart()
	}
}
