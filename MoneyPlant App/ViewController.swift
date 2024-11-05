//
//  ViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TransactionsTableViewCell else { return UITableViewCell() }
        
        cell.recordNameLabel.text = transactions[indexPath.row].name
        cell.recordImageView.image = transactions[indexPath.row].symbol
        cell.recordAmountLabel.text = "₹\( transactions[indexPath.row].amount)"
        cell.recordCategoryLabel.text = transactions[indexPath.row].category
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
}
