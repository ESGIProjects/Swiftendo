//
//  InterfaceController.swift
//  Swiftendo_AW Extension
//
//  Created by Kévin Le on 08/01/2018.
//  Copyright © 2018 ESGI. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    private var session: WCSession?
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
        startSession()
    }
	
	@IBAction func action() {
		send(message: "action")
	}
    
    private func startSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    private func send(message: String) {
		guard let session = session else { return }
		
        let data = [
			"action": message
		]
		
		session.sendMessage(data, replyHandler: nil)
    }
}

// MARK: - WCSessionDelegate
extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		
    }
}

