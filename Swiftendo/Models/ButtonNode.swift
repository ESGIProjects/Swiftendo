//
//  Button.swift
//  Swiftendo
//
//  Created by Jason Pierna on 05/12/2017.
//  Copyright © 2017 ESGI. All rights reserved.
//

import SpriteKit

enum Button: String {
	case up		= "buttonUp"
	case down	= "buttonDown"
	case left	= "buttonLeft"
	case right	= "buttonRight"
	case start	= "buttonStart"
	case action	= "buttonAction"
}

class ButtonNode: SKSpriteNode {
	
	var action: (() -> Void)?
	
	init(imageNamed imageName: String) {
		let texture = SKTexture(imageNamed: imageName)
		super.init(texture: texture, color: .clear, size: texture.size())
		isUserInteractionEnabled = true
		name = imageName
	}
	
	convenience init (button: Button) {
		self.init(imageNamed: button.rawValue)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		action?()
	}
}
