//
//  MyNetworkRequest.swift
//  RZ2 Project
//
//  Created by Eduardo Thiesen on 22/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import MobileCoreServices
import Foundation

class NetworkRequest: Operation, URLSessionDataDelegate {
    var sessionTask: URLSessionTask?
    var error: Error?
    var statusCode: Int?
    
    var localURLSession: URLSession? {
        URLCache.shared.removeAllCachedResponses()
        return URLSession(configuration: localConfig, delegate: self, delegateQueue: nil)
    }
    
    var localConfig: URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    
    let incomingData = NSMutableData()
    
    var internalFinished: Bool = false
    
    override var isFinished: Bool {
        get {
            return internalFinished
        }
        set (newAnswer) {
            willChangeValue(forKey: "isFinished")
            internalFinished = newAnswer
            didChangeValue(forKey: "isFinished")
        }
    }
    
    func processData() {}
    func processErrorData() {}
    
    //MARK: URL Session Data
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("DidReceive Response")
        if isCancelled {
            isFinished = true
            sessionTask?.cancel()
            return
        }
        //Check the response code and react appropriately
        statusCode = response.value(forKey: "statusCode") as? Int
        print(response)
        print("STATUS CODE: \(statusCode)")
        if  statusCode != 500 {
            completionHandler(.allow)
        } else {
            completionHandler(.cancel)
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("urlSessionDidFinishEvents")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("urlSessionDidReceiveChallenge")
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("urlSessionDidBecomeInvalidWithError")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("Data")
        if isCancelled {
            isFinished = true
            sessionTask?.cancel()
            return
        }
        
        incomingData.append(data as Data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("DidComplete")
        if isCancelled {
            isFinished = true
            task.cancel()
            return
        }
        
        if error != nil {
            self.error = error
            
            var userInfo : [String : Any] = [:]
            if (error?.localizedDescription.contains("Internet"))! {
                userInfo["Error"] = error?.localizedDescription
            
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNoInternetConnection"), object: self, userInfo: userInfo)
            }
            isFinished = true
            return
        }
        
        if statusCode != 200 && statusCode != 201 {
            processErrorData()
            isFinished = true
            return
        }
        
        processData()
        isFinished = true
    }
}
