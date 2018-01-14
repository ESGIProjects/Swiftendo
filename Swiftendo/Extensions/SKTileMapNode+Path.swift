//
//  SKTileMapNode+Path.swift
//  Swiftendo
//
//  Created by Jason Pierna on 13/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import SpriteKit
import GameplayKit

extension SKTileMapNode {
	
	func gridGraph() -> GKGridGraph<GKGridGraphNode>? {
		// Create graph
		let gridStart = vector_int2(
			Int32(-numberOfColumns/2),
			Int32(-numberOfRows/2)
		)
		
		let graph = GKGridGraph(fromGridStartingAt: gridStart,
								width: Int32(numberOfColumns),
								height: Int32(numberOfRows),
								diagonalsAllowed: false)
		
		var obstacles = [GKGridGraphNode]()
		
		// Loop through each tile to find obstacles
		for column in 0 ..< numberOfColumns {
			for row in 0 ..< numberOfRows {
				
				guard let definition = tileDefinition(atColumn: column, row: row) else { continue }
				guard let userData = definition.userData else { continue }
				guard let isObstacle = userData["isObstacle"] as? Bool else { continue }
				
				if isObstacle {
					// Add the obstacle to array
					if let node = graph.node(atGridPosition: vector_int2(Int32(column - numberOfColumns/2), Int32(row - numberOfRows/2))) {
						obstacles.append(node)
					}
				}
			}
		}
		
		// Delete obstacles from graph
		graph.remove(obstacles)
		
		return graph
	}
	
	func path(from startPoint: CGPoint, to endPoint: CGPoint) -> [SKAction] {
		
		var actions = [SKAction]()

		// Get the graph
		guard let graph = gridGraph() else { return actions }
		
		// Set start & end coordinates
		guard let start = graph.node(atGridPosition: int2(Int32(startPoint.x),Int32(startPoint.y))),
			let end = graph.node(atGridPosition: int2(Int32(endPoint.x),Int32(endPoint.y))) else {
			return actions
		}
		
		// Find the shortest path between start and end
		guard let path = graph.findPath(from: start, to: end) as? [GKGridGraphNode] else {
			return actions
		}
		
		if !path.isEmpty {
			
			// Looping through each piece of path
			for i in 1 ..< path.count {
				let previousX = Int(path[i-1].gridPosition.x)
				let previousY = Int(path[i-1].gridPosition.y)
				
				let x = Int(path[i].gridPosition.x)
				let y = Int(path[i].gridPosition.y)
				
				let deltaX = (CGFloat(x) - CGFloat(previousX)) * tileSize.width
				let deltaY = (CGFloat(y) - CGFloat(previousY)) * tileSize.height
				
				switch (deltaX, deltaY) {
				case (0, tileSize.height):
					actions.append(Player.moveTo(.up, duration: 0.1, sprite: "link"))
				case (0, -tileSize.height):
					actions.append(Player.moveTo(.down, duration: 0.1, sprite: "link"))
				case (-tileSize.width, 0):
					actions.append(Player.moveTo(.left, duration: 0.1, sprite: "link"))
				case (tileSize.width, 0):
					actions.append(Player.moveTo(.right, duration: 0.1, sprite: "link"))
				default:
					break;
				}
				
				actions.append(SKAction.wait(forDuration: 0.2))
				
				/*if let parent = parent {
					let pathNode = SKShapeNode(rectOf: CGSize(width: tileSize.width, height: tileSize.height))
					pathNode.position = CGPoint(x: CGFloat(x) * tileSize.width, y: CGFloat(y) * tileSize.height)
					pathNode.strokeColor = .red
					pathNode.zPosition = 0
					parent.addChild(pathNode)
				}*/
			}
		} else {
			print("Path is empty")
		}
		
		return actions
	}
}

