//
//  TransactionReviewViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 10/03/25.
//


import UIKit

class TransactionReviewViewController: UITableViewController {
    
    var transactions: [Transaction] = []
    @IBOutlet weak var transactionsReviewTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Transactions received: \(transactions)")
        
        navigationItem.title = "Review Transactions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTransactions))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelReview))
    }
    
    func addTransactions(_ transactions: [Transaction]) {
        for transaction in transactions {
            _ = PersistenceController.shared.addTransaction(
                paidTo: transaction.paidTo,
                amount: transaction.amount,
                date: transaction.date,
                note: "",
                categoryID: transaction.category.objectID
            )
        }
        print("Transactions saved to CoreData!")
    }

    @objc func saveTransactions() {
        print("✅ Transactions saved successfully!")
        performSegue(withIdentifier: "saveUnwindFromReview", sender: nil)
    }
    
    @objc func cancelReview() {
        for transaction in transactions {
            if transaction.managedObjectContext != nil {
                PersistenceController.shared.deleteTransaction(transaction: transaction)
            }
        }
        transactions.removeAll()
        print("❌ Transaction review cancelled.")
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       guard let transactionToEdit = sender as? Transaction else { return }
        if segue.identifier == "editReviewTransaction" {
            if let navController = segue.destination as? UINavigationController {
                if let addVC = navController.topViewController as? AddNewRecordTableViewController {
                    addVC.transactionToEdit = transactionToEdit
                }
            }
        }else if segue.identifier == "saveUnwindFromReview" {
            print("Unwinding to Transaction View Controller....")
        }
    }
    
    @IBAction func unwindToReviewViewController(_ segue: UIStoryboardSegue) {
        print("🔄 Unwound to TransactionReviewViewController")
        guard segue.identifier == "saveToReview",
              let sourceVC = segue.source as? AddNewRecordTableViewController else { return }
        transactionsReviewTable.reloadData()
        
    }

    // MARK: - TableView DataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TransactionsTableViewCell else {
            fatalError("❌ Failed to dequeue TransactionsTableViewCell")
        }
        
        let transaction = transactions[indexPath.row]
        cell.update(with: transaction)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transactionToEdit = transactions[indexPath.row]
        print("Selected transaction: \(String(describing: transactionToEdit.paidTo))")
        self.performSegue(withIdentifier: "editReviewTransaction", sender: transactionToEdit)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistenceController.shared.deleteTransaction(transaction: transactions[indexPath.row])
            PersistenceController.shared.saveContext()
            transactions.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
