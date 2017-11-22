//
//  LoginRequest.swift
//  RZ2 Project
//
//  Created by Eduardo Thiesen on 22/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import UIKit

class LoginRequest: NetworkRequest {
    var url: String
    var email: String
    var password: String
    
    init(url: String, email: String, password: String) {
        self.url = url
        self.email = email
        self.password = password
    }
    
    override func start() {
        let params = ["email" : email,
                      "password" : password] as [String : Any]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
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
