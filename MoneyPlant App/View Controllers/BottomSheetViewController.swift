//
//  BottomSheetViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 16/12/24.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var dailyTasksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}

extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        dailyTasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetCell", for: indexPath) as? DailyTaskTableViewCell else { return UITableViewCell() }
        
        cell.dateLabel.text = dailyTasks[indexPath.row].date
        cell.targetAmountLabel.text = "Save Rs. \( dailyTasks[indexPath.row].targetAmount)"
        cell.taskProgress.image = dailyTasks[indexPath.row].taskProgress
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    
}
