//
//  RZ2_ProjectTests.swift
//  RZ2 ProjectTests
//
//  Created by Eduardo Thiesen on 23/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import XCTest
@testable import RZ2_Project

class RZ2_ProjectTests: XCTestCase {
    
    var controllerUnderTest: UnitsViewController!
    
    override func setUp() {
        super.setUp()
        
        controllerUnderTest = UIStoryboard(name: "Main",
                                           bundle: nil).instantiateViewController(withIdentifier: "UnitsViewController") as! UnitsViewController
    }
    
    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }
    
    func testJsonParseAndAddingObjects() {
        DataManager.shared.deleteData()
        
        XCTAssertEqual(DataManager.shared.retrieveUnits().count, 0, "No data on the local database")
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "testData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        let retrieveUnitsRequest = RetrieveUnitsRequest(url: "")
        retrieveUnitsRequest.incomingData.append(data!)
        retrieveUnitsRequest.processData()
        
        XCTAssertEqual(DataManager.shared.retrieveUnits().count, 2, "Two units saved")
    }
    
    func testControllerReceivingData() {
        DataManager.shared.deleteData()
        
        XCTAssertEqual(controllerUnderTest.unitsDataSource.count, 0, "No data on the local database")
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "testData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        let retrieveUnitsRequest = RetrieveUnitsRequest(url: "")
        retrieveUnitsRequest.incomingData.append(data!)
        retrieveUnitsRequest.processData()
        
        controllerUnderTest.didRetrieveUnits(notification: Notification(name: Notification.Name(rawValue: "kDidReceiveRetrieveUnits")))
        XCTAssertEqual(controllerUnderTest.unitsDataSource.count, 2, "Two units saved")
    }
    
}
