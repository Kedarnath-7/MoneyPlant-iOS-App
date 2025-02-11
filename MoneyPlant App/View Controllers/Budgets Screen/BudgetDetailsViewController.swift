//
//  BudgetDetailsViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 05/01/25.
//

import UIKit

class BudgetDetailsViewController: UIViewController {

    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var daysLeftLbl: UILabel!
    @IBOutlet weak var amountLeftLbl: UILabel!
    @IBOutlet weak var amountLeftForEachDayLbl: UILabel!
    @IBOutlet weak var amountSpentLbl: UILabel!
    @IBOutlet weak var addOrEditCategoryBudget: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var noCategoryTransactionsView: UIView!
    @IBOutlet weak var categoryTransactionsView: UIView!
    
    var selectedCategoryBudget: CategoryBudget?
    var categoryTransactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadTransactions()
    }

    func setupUI() {
        guard let categoryBudget = selectedCategoryBudget else {
            showError("No category budget selected.")
            return
        }

        // Set category name and image
        categoryNameLbl.text = categoryBudget.category.name
        categoryImage.image = UIImage(data: categoryBudget.category.icon)

        // Calculate days left
        let budget = categoryBudget.budget
        daysLeftLbl.text = "\(PersistenceController.shared.daysLeftInMonth(from: budget.monthYear) ?? 0) days left"

        // Calculate financial details
        let totalBudget = categoryBudget.budgetedAmount
        let spent = categoryBudget.spentAmount
        let remaining = totalBudget - spent
        let daysLeft = Double(daysLeftLbl.text?.split(separator: " ").first ?? "0") ?? 1.0
        let perDay = remaining / daysLeft

        amountLeftLbl.text = String(format: "₹ %.2f", remaining)
        amountSpentLbl.text = String(format: "₹ %.2f Spent", spent)
        amountLeftForEachDayLbl.text = String(format: "₹ %.2f", perDay)
        let title = String("₹\(categoryBudget.budgetedAmount)")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium)
        ]

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        addOrEditCategoryBudget.setAttributedTitle(attributedTitle, for: .normal)
        progressView.progress = Float(spent.isZero || totalBudget.isZero ? 0 : spent / totalBudget)
    }
    
    func updateTableView() {
        let hasTransactions = !categoryTransactions.isEmpty
        UIView.animate(withDuration: 0.3) {
            self.noCategoryTransactionsView.isHidden = hasTransactions
            self.categoryTransactionsView.isHidden = !hasTransactions
        }
        
        if let containerVC = children.last as? CategoryTransactionsTableViewController {
            containerVC.forCategoryBudget = selectedCategoryBudget
            containerVC.transactionsList = categoryTransactions
            containerVC.categoryTransactionsTableView.reloadData()
        }
    }

    func loadTransactions() {
        guard let categoryBudget = selectedCategoryBudget else {
            categoryTransactions = []
            return
        }
        
        let monthYearFormatter = DateFormatter()
        monthYearFormatter.dateFormat = "MMM yyyy"
        categoryTransactions = PersistenceController.shared.fetchTransactions().filter { transaction in
            guard transaction.category == categoryBudget.category else { return false }

            let transactionMonthYear = monthYearFormatter.string(from: transaction.date)
            return transactionMonthYear == categoryBudget.budget.monthYear
        }
        
        updateTableView()
    }

    @IBAction func didTapEditCategoryBudget(_ sender: UIButton) {
        // Navigate to Add/Edit Budget Screen
        performSegue(withIdentifier: "editCategoryBudgetSegue", sender: selectedCategoryBudget)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let categoryBudget = sender as? CategoryBudget else { return }
        if segue.identifier == "editCategoryBudgetSegue", let navController = segue.destination as? UINavigationController {
                if let destinationVC = navController.topViewController as? AddNewBudgetTableViewController {
                // Pass category budget to Add/Edit Budget Screen
                destinationVC.existingCategoryBudget = categoryBudget
                destinationVC.selectedCategory = categoryBudget.category
                }
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
