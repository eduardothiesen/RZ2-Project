//
//  RetrieveUnitsRequest.swift
//  RZ2 Project
//
//  Created by Eduardo Thiesen on 22/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import UIKit

class RetrieveUnitsRequest: NetworkRequest {
    private var url: String
    
    init(url: String) {
        self.url = url
    }
    
    override func start() {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + KeychainWrapper.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        sessionTask = localURLSession?.dataTask(with: request)
        sessionTask?.resume()
    }
    
    override func processData() {
        let data = try! JSONSerialization.jsonObject(with: incomingData as Data, options: .allowFragments) as! [String : Any]
        
        let response = data["data"] as! [String : Any]
        let units = response["units"] as! Array<[String : Any]>
        
        for unit in units {
            DataManager.shared.addUnit(unit: unit)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kDidReceiveRetrieveUnits"), object: nil, userInfo: nil)
    }
    
    override func processErrorData() {
        let data = try! JSONSerialization.jsonObject(with: incomingData as Data, options: .allowFragments) as! [String : Any]
        
        var userInfo: [String : Any] = [:]
        var description = ""
        
        //TODO: Treat error that should force logout 
        if let error = (data["message"] as? String) {
            description = error
        } else {
            description = "Algo deu errado. Tente novamente mais tarde."
        }
        
        userInfo["Error"] = description
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kDidReceiveRetrieveUnitsError"), object: nil, userInfo: userInfo)
        
    }
}
