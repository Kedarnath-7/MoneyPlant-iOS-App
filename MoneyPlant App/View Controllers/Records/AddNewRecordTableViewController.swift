//
//  AddNewRecordTableViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/11/24.
//

import UIKit

class AddNewRecordTableViewController: UITableViewController {
    
    var transaction: Transaction?
    var selectedCategory: Category?
    var selectedExpenseCategory: Category?
    var selectedIncomeCategory: Category?
    
    @IBOutlet weak var selectedCategoryImage: UIImageView!

    @IBOutlet weak var selectedCategoryName: UITextField!
    
    @IBOutlet weak var selectedCategoryAmount: UITextField!
    
    @IBOutlet weak var selectedCategoryDate: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var selectedCategoryNote: UITextField!
    
    @IBOutlet weak var saveRecordButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let expenceCategory = selectedExpenseCategory {
            selectedCategory = expenceCategory
            selectedCategory?.type = expenceCategory.type
            print("selectedExpenseCategory Data passed")
            selectedCategoryImage.image = UIImage(data: expenceCategory.icon)
            navigationItem.title = "Add New Expense Record"
        }
        else if let incomeCategory = selectedIncomeCategory {
             selectedCategory = incomeCategory
             selectedCategory?.type = incomeCategory.type
             print("selectedIncomeCategory Data passed")
            selectedCategoryImage.image = UIImage(data: incomeCategory.icon)
             navigationItem.title = "Add New Income Record"
        }else if let transactionToEdit = transaction{
            selectedCategory = transactionToEdit.category
            selectedCategoryImage.image = UIImage(data: transactionToEdit.category.icon)
            selectedCategory?.type = transactionToEdit.category.type
            selectedCategoryName.text = transactionToEdit.paidTo
            selectedCategoryAmount.text = String(transactionToEdit.amount)
            datePicker.date = transactionToEdit.date
            selectedCategoryNote.text = transactionToEdit.note
            print("editTransaction Data passed")
            navigationItem.title = "Edit Transaction"
        }
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let paidTo = selectedCategoryName.text ?? ""
        let categoryAmount = selectedCategoryAmount.text ?? ""

        saveRecordButton.isEnabled = !paidTo.isEmpty && !categoryAmount.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let destinationVC = segue.destination as! TransactionsViewController
        
        let paidTo = (selectedCategoryName?.text)!
        let category = selectedCategory!
        
        guard let amount = Double(selectedCategoryAmount.text ?? "") else {
            showError("Invalid amount")
            return
        }
        let dateAndTime = datePicker.date
        let note = selectedCategoryNote.text ?? ""
        let type = (selectedCategory?.type)!
        let id = UUID()
        
        transaction = Transaction(context: PersistenceController.shared.context)
        transaction?.id = id
        transaction?.amount = amount
        transaction?.date = dateAndTime
        transaction?.paidTo = paidTo
        transaction?.note = note
        transaction?.category = category
        transaction?.type = type
        
       // PersistenceController.shared.addTransaction(id: id, amount: amount, date: dateAndTime, paidTo: paidTo, note: note, category: category, type: type)
    }
    
    @IBAction func editCoverTapped(_ sender: Any) {
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
