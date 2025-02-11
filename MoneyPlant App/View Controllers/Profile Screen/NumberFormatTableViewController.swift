//
//  NumberFormatTableViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 27/12/24.
//

import UIKit

class NumberFormatTableViewController: UITableViewController {
    let numberFormats = [
         "12,34,567.89",
         "12.34.567,89",
         "12 34 567.89",
         "12 34 567,89"
     ]
     
     // Track the selected format
     var selectedFormatIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Number Format"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NumberFormatCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberFormats.count    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumberFormatCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = numberFormats[indexPath.row]
        cell.accessoryType = (indexPath.row == selectedFormatIndex) ? .checkmark : .none
        cell.backgroundColor = .systemGray6
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Update the selected format
           selectedFormatIndex = indexPath.row
           
           // Reload the table to update the checkmark
           tableView.reloadData()
       }

}
