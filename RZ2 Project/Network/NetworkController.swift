//
//  NetworkController.swift
//  RZ2 Project
//
//  Created by Eduardo Thiesen on 22/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
    
    let baseURL = "http://54.208.92.83/checklist_novo/Application/public/mobile"
    
    func login(email: String, password: String) {
        let loginRequest = LoginRequest(url: baseURL + "/login", email: email, password: password)
        loginRequest.start()
    }
    
    func retrieveUnits() {
        let retrieveUnitsRequest = RetrieveUnitsRequest(url: baseURL + "/units")
        retrieveUnitsRequest.start()
    }
}
