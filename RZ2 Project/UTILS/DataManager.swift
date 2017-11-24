//
//  DataManager.swift
//  RZ2 Project
//
//  Created by Eduardo Thiesen on 24/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DataManager {
    
    static let shared = DataManager()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    init() {
        context = appDelegate.persistentContainer.viewContext
    }
    
    func addUnit(unit: [String : Any]) {
        let unitModel = Unit(context: context)
        
        unitModel.id = unit["id"] as! Int32
        unitModel.name = unit["name"] as? String
        unitModel.email = unit["email"] as? String
        unitModel.address = unit["address"] as? String
        if let latitude = unit["latitude"] as? Float {
            unitModel.latitude = latitude
        }
        if let longitude = unit["longitude"] as? Float {
            unitModel.longitude = longitude
        }
        unitModel.type = unit["type"] as? String
        unitModel.checklistIDs = unit["checklist_ids"] as? [Int32]
        unitModel.regionIDs = unit["region_ids"] as? [Int32]
        unitModel.additionalFields = unit["additional_fields"] as? [Any]
        unitModel.qrCode = unit["qr_code"] as? String
        
        addCountry(country: unit["country"] as! [String : Any], unit: unitModel)
        addState(state: unit["state"] as! [String : Any], unit: unitModel)
        addCity(city: unit["city"] as! [String : Any], unit: unitModel)
        
        appDelegate.saveContext()
    }
    
    func addCountry(country: [String : Any], unit: Unit?) {
        let countryModel = Country(context: context)
        
        countryModel.id = country["id"] as! Int32
        countryModel.nameBr = country["nameBr"] as? String
        countryModel.nameEn = country["nameEn"] as? String
        countryModel.nameEs = country["nameEs"] as? String
        
        if unit != nil {
            countryModel.addToUnits(unit!)
        }
        
        appDelegate.saveContext()
    }
    
    func addState(state: [String : Any], unit: Unit?) {
        let stateModel = State(context: context)
        
        stateModel.id = state["id"] as! Int32
        stateModel.name = state["name"] as? String
        
        if unit != nil {
            stateModel.addToUnits(unit!)
        }
        
        appDelegate.saveContext()
    }
    
    func addCity(city: [String : Any], unit: Unit?) {
        let cityModel = City(context: context)
        
        cityModel.id = city["id"] as! Int32
        cityModel.name = city["name"] as? String
        
        if unit != nil {
            cityModel.addToUnits(unit!)
        }
        
        appDelegate.saveContext()
    }
    
    func retrieveUnits() -> [Unit] {
        return try! context.fetch(Unit.fetchRequest())
    }
    
    func deleteData() {
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Unit")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch _ as NSError {
            // TODO: handle the error
        }
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch _ as NSError {
            // TODO: handle the error
        }
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "State")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch _ as NSError {
            // TODO: handle the error
        }
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch _ as NSError {
            // TODO: handle the error
        }
    }
}
