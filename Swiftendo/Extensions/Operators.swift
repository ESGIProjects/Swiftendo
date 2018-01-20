//
//  Operators.swift
//  Swiftendo
//
//  Created by Jason Pierna on 20/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import UIKit

func +(lhs: CGFloat, rhs: Double) -> CGFloat {
	return lhs + CGFloat(rhs)
}

func +(lhs: Double, rhs: CGFloat) -> CGFloat {
	return CGFloat(lhs) + rhs
}

func -(lhs: CGFloat, rhs: Double) -> CGFloat {
	return lhs + (-rhs)
}

func -(lhs: Double, rhs: CGFloat) -> CGFloat {
	return lhs + (-rhs)
}
