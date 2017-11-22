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
        //TODO: ARRUMAR TOKEN
        request.addValue("token", forHTTPHeaderField: "Authorization")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        sessionTask = localURLSession?.dataTask(with: request)
        sessionTask?.resume()
    }
    
    override func processData() {
        let data = try! JSONSerialization.jsonObject(with: incomingData as Data, options: .allowFragments) as! [String : Any]
        print(data)
    }
    
    override func processErrorData() {
        let data = try! JSONSerialization.jsonObject(with: incomingData as Data, options: .allowFragments) as! [String : Any]
        print(data)
    }
}
