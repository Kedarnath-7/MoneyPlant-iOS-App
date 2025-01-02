//
//  BudgetViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 31/12/24.
//

import UIKit

class BudgetViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var remainingBudgetLabel: UILabel!
    @IBOutlet weak var totalExpensesLabel: UILabel!

    var currentMonth: String {
        // Fetch the current month and year in "MM-yyyy" format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"
        return dateFormatter.string(from: Date())
    }

    var currentBudget: Double {
        // Fetch the current budget amount from Core Data
        return PersistenceController.shared.fetchBudget(for: currentMonth)?.budgetAmount ?? 0.0
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update the income and summary on load
        updateIncome()
        updateSummary()
    }

    // MARK: - Helper Methods
    func fetchTotalIncome() -> Double {
        let incomeTransactions = PersistenceController.shared.fetchTransactions().filter { $0.type == "Income" }
        return incomeTransactions.reduce(0) { $0 + $1.amount }
    }

    func fetchTotalExpenses() -> Double {
        let expenseTransactions = PersistenceController.shared.fetchTransactions().filter { $0.type == "Expense" }
        return expenseTransactions.reduce(0) { $0 + $1.amount }
    }

    func updateIncome() {
        let totalIncome = fetchTotalIncome()
        totalIncomeLabel.text = "₹\(String(format: "%.2f", totalIncome))"
    }

    func updateSummary() {
        let totalExpenses = fetchTotalExpenses()
        let remainingBudget = currentBudget - totalExpenses

        totalExpensesLabel.text = "₹\(String(format: "%.2f", totalExpenses))"
        remainingBudgetLabel.text = "₹\(String(format: "%.2f", remainingBudget))"
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Actions
    @IBAction func saveBudgetTapped(_ sender: UIButton) {
        guard let budgetText = budgetTextField.text, let budgetAmount = Double(budgetText) else {
            showError("Please enter a valid budget amount.")
            return
        }

        // Check if a budget already exists for the current month
        if let existingBudget = PersistenceController.shared.fetchBudget(for: currentMonth) {
            // Update the existing budget
            existingBudget.budgetAmount = budgetAmount
            PersistenceController.shared.saveContext()
            print("Budget updated for \(currentMonth).")
        } else {
            // Create a new budget
            let totalIncome = fetchTotalIncome()
            PersistenceController.shared.createBudget(monthYear: currentMonth, income: totalIncome, budgetAmount: budgetAmount)
        }

        // Generate daily targets for the budget
        if let budget = PersistenceController.shared.fetchBudget(for: currentMonth) {
            PersistenceController.shared.generateDailyTargets(for: budget)
        }

        // Update the summary section
        updateSummary()

        // Show success message
        let alert = UIAlertController(title: "Success", message: "Budget saved successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
