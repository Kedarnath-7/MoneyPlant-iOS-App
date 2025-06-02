//
//  AddNewRecordTableViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/11/24.
//

import UIKit

class AddNewRecordTableViewController: UITableViewController {

    var addedTransaction: Transaction?
    var transactionToEdit: Transaction?
    var selectedCategory: Category?
    var selectedExpenseCategory: Category?
    var selectedIncomeCategory: Category?

    @IBOutlet weak var selectedCategoryLabel: UILabel!
    @IBOutlet weak var selectedCategoryName: UITextField!
    @IBOutlet weak var selectedCategoryAmount: UITextField!
    @IBOutlet weak var categoryUIView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedCategoryNote: UITextField!
    @IBOutlet weak var saveRecordButton: UIBarButtonItem!
    @IBOutlet weak var recurrenceSegmentedControl: UISegmentedControl!

    private var selectedRecurrence: String = "none" // Default to "none"

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryUIView.layer.cornerRadius = 100
        categoryUIView.layer.borderWidth = 8
        categoryUIView.layer.borderColor = UIColor.systemGray4.cgColor
        
        // Initialize the segmented control with default selection
        recurrenceSegmentedControl.selectedSegmentIndex = 0 // "None"
        
        if let expenseCategory = selectedExpenseCategory {
            selectedCategory = expenseCategory
            selectedCategory?.type = expenseCategory.type
            print("selectedExpenseCategory Data passed")
            selectedCategoryLabel.text = expenseCategory.icon
            navigationItem.title = "Add New Expense Record"
        }
        else if let incomeCategory = selectedIncomeCategory {
            selectedCategory = incomeCategory
            selectedCategory?.type = incomeCategory.type
            print("selectedIncomeCategory Data passed")
            selectedCategoryLabel.text = incomeCategory.icon
            navigationItem.title = "Add New Income Record"
        }
        else if let transactionToEdit = transactionToEdit {
            selectedCategory = transactionToEdit.category
            selectedCategoryLabel.text = transactionToEdit.category.icon
            selectedCategory?.type = transactionToEdit.category.type
            selectedCategoryName.text = transactionToEdit.paidTo
            selectedCategoryAmount.text = String(transactionToEdit.amount)
            datePicker.date = transactionToEdit.date
            selectedCategoryNote.text = transactionToEdit.note
            // Set the recurrence type if editing an existing transaction
            selectedRecurrence = transactionToEdit.recurrence
            switch selectedRecurrence {
            case "daily":
                recurrenceSegmentedControl.selectedSegmentIndex = 1
            case "weekly":
                recurrenceSegmentedControl.selectedSegmentIndex = 2
            case "monthly":
                recurrenceSegmentedControl.selectedSegmentIndex = 3
            default:
                recurrenceSegmentedControl.selectedSegmentIndex = 0
            }
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

    @IBAction func recurrenceChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedRecurrence = "none"
        case 1:
            selectedRecurrence = "daily"
        case 2:
            selectedRecurrence = "weekly"
        case 3:
            selectedRecurrence = "monthly"
        default:
            selectedRecurrence = "none"
        }
        print("Selected recurrence: \(selectedRecurrence)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let paidTo = selectedCategoryName.text ?? ""
        let category = selectedCategory!
        guard let amount = Double(selectedCategoryAmount.text ?? "") else {
            showError("Invalid amount")
            return
        }
        datePicker.timeZone = TimeZone.current
        let dateAndTime = datePicker.date
        print("Selected Transaction date and time: \(dateAndTime)")
        let note = selectedCategoryNote.text ?? ""
        
        if let transactionToEdit = transactionToEdit {
            PersistenceController.shared.updateTransaction(transaction: transactionToEdit, paidTo: paidTo, amount: amount, date: dateAndTime, note: note, recurrence: selectedRecurrence)
        } else {
            addedTransaction = PersistenceController.shared.addTransaction(paidTo: paidTo, amount: amount, date: dateAndTime, note: note, categoryID: category.objectID, recurrence: selectedRecurrence)
        }
        if segue.identifier == "saveUnwind" {
            print("✅ Unwinding to TransactionsViewController")
        }
        else if segue.identifier == "saveToReview" {
            print("✅ Unwinding to TransactionReviewViewController")
        }
    }

    @IBAction func editCoverTapped(_ sender: Any) {
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
