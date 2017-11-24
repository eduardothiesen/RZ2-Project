//
//  TableViewController.swift
//  RZ2 Project
//
//  Created by Eduardo Thiesen on 23/11/17.
//  Copyright © 2017 Thiesen. All rights reserved.
//

import UIKit
import CoreData

class UnitsViewController: UIViewController {

    var unitsDataSource: [Unit] = []
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var loader: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkController = NetworkController()
        networkController.retrieveUnits()
        
        unitsDataSource = DataManager.shared.retrieveUnits()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UnitsViewController.didRetrieveUnits(notification:)), name: NSNotification.Name(rawValue: "kDidReceiveRetrieveUnits"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UnitsViewController.didReceiveRetrieveUnitsError(notification:)), name: NSNotification.Name(rawValue: "kDidReceiveRetrieveUnitsError"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UnitsViewController.didReceiveInternetConnectionError(notification:)), name: NSNotification.Name(rawValue: "kNoInternetConnection"), object: nil)
        
        tableView?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func enableFields() {
        
    }
    
    func disableFields() {
        
    }
    
    @objc func didRetrieveUnits(notification: Notification) {
        
        unitsDataSource = DataManager.shared.retrieveUnits()
        
        DispatchQueue.main.async(execute: {
            self.enableFields()
            self.loader?.stopAnimating()
            self.tableView?.reloadData()
        })
    }
    
    @objc func didReceiveInternetConnectionError(notification: Notification) {
        let userInfo = notification.userInfo as! [String : Any]
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "", message: userInfo["Error"] as? String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.enableFields()
            self.loader?.stopAnimating()
        })
    }
    
    @objc func didReceiveRetrieveUnitsError(notification: Notification) {
        let userInfo = notification.userInfo as! [String : Any]
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "", message: userInfo["Error"] as? String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.enableFields()
            self.loader?.stopAnimating()
        })
    }
}

extension UnitsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        
        let unit = unitsDataSource[indexPath.row]
        
        cell.textLabel?.text = unit.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
