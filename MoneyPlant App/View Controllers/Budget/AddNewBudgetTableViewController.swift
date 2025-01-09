//
//  AddNewBudgetViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 05/01/25.
//

import UIKit

class AddNewBudgetTableViewController: UITableViewController {

    @IBOutlet weak var selectedCategoryImage: UIImageView!
    @IBOutlet weak var selectedCategoryName: UILabel!
    @IBOutlet weak var categoryBudgetTextField: UITextField!
    @IBOutlet weak var saveBudgetButton: UIBarButtonItem!

    var totalBudget: Budget? // Represents the total budget for the month
    var existingCategoryBudget: CategoryBudget? // Represents the category-specific budget
    var newCategoryBudget: CategoryBudget?
    var selectedCategory: Category? // Category to assign the budget to

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("new Categoty budget data received from CategoriesCollectionViewController: \(String(describing: newCategoryBudget))")

        setupUI()
        categoryBudgetTextField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
    }

    func setupUI() {
        if let budget = totalBudget{
            print("Total budget data received from BudgetsViewController: \(budget.description)")
            // Adding/Editing the total budget
            selectedCategoryName.text = "Total Budget"
            selectedCategoryImage.image = UIImage(named: "indianrupeesign.circle")
            categoryBudgetTextField.text = String(format: "%.2f", budget.budgetedAmount)
            navigationItem.title = "Add/Edit Total Budget"
        }else{
//            if let selectedCategory = selectedCategory{
//                newCategoryBudget = PersistenceController.shared.fetchCategoryBudget(for: selectedCategory, monthYear: <#T##String#>)
//            }
            if let categoryBudget = existingCategoryBudget{
                selectedCategoryName.text = categoryBudget.category.name
                selectedCategoryImage.image = UIImage(data: categoryBudget.category.icon)
                categoryBudgetTextField.text = String(format: "%.2f", categoryBudget.budgetedAmount)
                navigationItem.title = "Edit \(categoryBudget.category.name) Budget"
            }else if let newCategoryBudget = newCategoryBudget{
                selectedCategoryName.text = newCategoryBudget.category.name
                selectedCategoryImage.image = UIImage(data: newCategoryBudget.category.icon)
                categoryBudgetTextField.text = String(format: "%.2f", newCategoryBudget.budgetedAmount)
                navigationItem.title = "Add New \(newCategoryBudget.category.name) Budget"
            }
        }
        updateSaveBudgetButton()
    }

    func updateSaveBudgetButton() {
        let budgetAmount = categoryBudgetTextField.text ?? ""
        saveBudgetButton.isEnabled = !budgetAmount.isEmpty && Double(budgetAmount) != nil
    }

    @objc func textEditingChanged(_ sender: UITextField) {
        updateSaveBudgetButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveBudget" else { return }

        guard let amountText = categoryBudgetTextField.text,
              let amount = Double(amountText), amount > 0 else {
            showError("Please enter a valid budget amount.")
            return
        }
        
        if let budget = totalBudget {
            // Save or update the total budget
            PersistenceController.shared.updateBudget(budget: budget, income: nil, budgetAmount: amount, totalExpenses: nil)
        }else{
            // Save or update the category budget
            if let existingCategoryBudget = existingCategoryBudget {
                PersistenceController.shared.updateCategoryBudget(categoryBudget: existingCategoryBudget, spentAmount: nil, budgetedAmount: amount)
            }else if let newCategoryBudget = newCategoryBudget {
                PersistenceController.shared.updateCategoryBudget(categoryBudget: newCategoryBudget, spentAmount: nil, budgetedAmount: amount)
            }
        }
    }

    // Helper function to show errors
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
