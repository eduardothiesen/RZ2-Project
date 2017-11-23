//
//  TableViewController.swift
//  RZ2 Project
//
//  Created by Eduardo Thiesen on 23/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var unitsDataSource: [Unit]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = appDelegate.persistentContainer.viewContext
        
        let networkController = NetworkController()
        networkController.retrieveUnits()
        
        do {
            unitsDataSource = try context.fetch(Unit.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitsDataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)

        let unit = unitsDataSource[indexPath.row]
        
        cell.textLabel?.text = unit.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
