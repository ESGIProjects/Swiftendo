//
//  Button.swift
//  Swiftendo
//
//  Created by Jason Pierna on 05/12/2017.
//  Copyright © 2017 ESGI. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {
	
	var type: ButtonType
	var action: (() -> Void)?
	
	init (type: ButtonType) {
		self.type = type
		let texture = SKTexture(imageNamed: type.rawValue)
		super.init(texture: texture, color: .clear, size: texture.size())
		
		isUserInteractionEnabled = true
		name = type.rawValue
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		action?()
	}
}
