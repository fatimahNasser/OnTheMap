//
//  TableViewController.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-22.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        tableView.reloadData()
        activityIndicator.hidesWhenStopped = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsData.toShare.studentLocationsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.tableCell(location: LocationsData.toShare.studentLocationsData[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: LocationsData.toShare.studentLocationsData[indexPath.row].mediaURL!)!,options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    fileprivate func updateData() {
        
        activityIndicator.startAnimating()
        APIFunc.getStudentLocations { (locations) in
            
            if locations == nil || (locations?.studentLocationsData.isEmpty)! {
                    let alert = UIAlertController(title: "ERROR", message: "Locations Data is not available", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        for location in (locations?.studentLocationsData)! {
                            LocationsData.toShare.studentLocationsData.append(location)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    
    
    @IBAction func refreshButton(_ sender: Any) {
        updateData()
        tableView.reloadData()
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        APIFunc.sharedInstance.logout{ (false, error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    }

