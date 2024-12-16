//
//  TransactionsTableViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 06/11/24.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    @IBOutlet weak var transactionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func unwindToTransactionsTableView(segue: UIStoryboardSegue){
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddNewRecordTableViewController,
              let transaction = sourceViewController.transaction else { return }
        
        transactions.insert(transaction, at: 0)
        transactionsTableView.reloadData()
        
//            if category.type == "Expense"{
//                expenseCategories.insert(category, at: expenseCategories.count - 1)
//                let newIndexPath = IndexPath(row: expenseCategories.count - 2, section: 0)
//                print("Inserting new item at indexPath: \(newIndexPath)")
//                 
//                if let collectionView = expenseCategoriesCollectionView {
//                    collectionView.reloadData()
//                    
//                } else {
//                    print("expenseCategoriesCollectionView is nil!")
//                }
//                print("New Expense Category Inserted: \(category.name)")
//                
//            }else{
//                incomeCategories.insert(category, at: incomeCategories.count - 1)
//                
//                let newIndexPath = IndexPath(row: incomeCategories.count - 2, section: 0)
//
//                print("Inserting new item at indexPath: \(newIndexPath)")
//                
//                if let collectionView = incomeCategoriesCollectionView {
//                    collectionView.reloadData()
//                } else {
//                    print("incomeCategoriesCollectionView is nil!")
//                }
//                print("New Income Category Inserted: \(category.name)")
//                
//            }
    }
    
}

    // MARK: - Table view data source
extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TransactionsTableViewCell else { return UITableViewCell() }
        
        cell.recordNameLabel.text = transactions[indexPath.row].name
        cell.recordImageView.image = transactions[indexPath.row].symbol
        cell.recordAmountLabel.text = "₹\( transactions[indexPath.row].amount)"
        cell.recordCategoryLabel.text = transactions[indexPath.row].category
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }

}
