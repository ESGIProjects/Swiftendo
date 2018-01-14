//
//  InterfaceController.swift
//  Swiftendo_AW Extension
//
//  Created by Kévin Le on 08/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController{
    
    var session: WCSession?
    
    @IBAction func action() {
        send(data: "action")
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        startSession()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func startSession(){
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    
    func send(data: String){
        let data = ["action":data]
        session?.sendMessage(data, replyHandler: nil)
    }
}

extension InterfaceController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}

