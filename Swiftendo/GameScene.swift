//
//  GameScene.swift
//  Swiftendo
//
//  Created by Kévin Le on 20/11/2017.
//  Copyright © 2017 ESGI. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, AVAudioPlayerDelegate {
    
    var backgroundMusic: AVAudioPlayer!
    var musicNumber: Int = 0
    var path : String!
    
    let musicList = ["Sounds/Hyrule_Castle_SNES.mp3","Sounds/Hyrule_Field_SNES.mp3","Sounds/Dark_World_SNES.mp3",
                     "Sounds/Hyrule_Field_Wii.mp3","Sounds/Lost_Woods_N64.mp3","Sounds/Gerudo_Valley_N64",
                     "Sounds/Tal_Tal_Mountain_GB.mp3"]
    
    override func didMove(to view: SKView) {
        playBackgroundMusic()
    }
    
    func playBackgroundMusic() {
        
        musicNumber = Int(arc4random_uniform(UInt32(musicList.count)))
        
        let path = Bundle.main.path(forResource: musicList[musicNumber], ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do{
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic.play()
            backgroundMusic.delegate = self as AVAudioPlayerDelegate
        }
        catch{
            print("Can't load the music !")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBackgroundMusic()
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
