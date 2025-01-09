//
//  CategoryTransactionsTableViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 09/01/25.
//

import UIKit

class CategoryTransactionsTableViewController: UIViewController {
    
    @IBOutlet weak var categoryTransactionsTableView: UITableView!
    
    var forCategoryBudget: CategoryBudget?
    var transactionsList: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Entered Transactions Table View Controller...")
        print("Checking for updated transactions...")
        print("Number of Transactions found in Transactions List: \(transactionsList.count)")
        updateTableView()
    }
    
    func updateTableView() {
        print("Entered Update Table View function....")
        transactionsList = PersistenceController.shared.fetchTransactions()
        
        print("fetching all the transactions...")
        print("Number of transactions: \(transactionsList.count)")
        categoryTransactionsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       guard let transactionToEdit = sender as? Transaction else { return }
        
        if segue.identifier == "editTransaction" {
            if let navController = segue.destination as? UINavigationController {
                if let addVC = navController.topViewController as? AddNewRecordTableViewController {
                    addVC.transaction = transactionToEdit
                }
            }
        }
    }
}

// MARK: - Table view data source

extension CategoryTransactionsTableViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TransactionsTableViewCell else { return UITableViewCell() }
        
        cell.update(with: transactionsList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transactionToEdit = transactionsList[indexPath.row]
        print("Selected transaction: \(String(describing: transactionToEdit.paidTo))")
        self.performSegue(withIdentifier: "editTransaction", sender: transactionToEdit)
        
    }
    
    //Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistenceController.shared.deleteTransaction(transactionsList[indexPath.row])
            PersistenceController.shared.saveContext()
            transactionsList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }

}
