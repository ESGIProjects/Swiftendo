//
//  GameScene.swift
//  Swiftendo
//
//  Created by Kévin Le on 20/11/2017.
//  Copyright © 2017 ESGI. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var random : UInt32 = 0
    var backgroundMusic: SKAudioNode!
    let fadeOut = SKAction.fadeOut(withDuration: 1)
    let remove = SKAction.removeFromParent()
    let wait = SKAction.wait(forDuration: 0.5)
    let musics = [Bundle.main.url(forResource: "Dark_World", withExtension: "mp3", subdirectory: "Sounds/"),
                  Bundle.main.url(forResource: "Hyrule_Castle", withExtension: "mp3", subdirectory: "Sounds/"),
                  Bundle.main.url(forResource: "Hyrule_Field", withExtension: "mp3", subdirectory: "Sounds/")]
    
    override func didMove(to view: SKView) {
        playBackgroundMusic()
    }
    
    func playBackgroundMusic() {
        random = arc4random_uniform(_:UInt32(musics.count))
        backgroundMusic = SKAudioNode(url: musics[Int(random)]!)
        addChild(backgroundMusic)
        backgroundMusic.run(SKAction.play())
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
