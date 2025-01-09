//
//  BudgetsTableViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 05/01/25.
//

import UIKit

class BudgetsTableViewController: UIViewController {

    @IBOutlet weak var categoriesBudgetTableView: UITableView!
    
    var forBudget: Budget?
    var categoriesBudgetList: [CategoryBudget] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Entered BudgetsTableViewController...")
        print("Checking for updated category budgets...")
        print("Number of budgets found in budgetList: \(categoriesBudgetList.count)")
        updateTableView()
    }

    func updateTableView() {
        print("Entered update table view function...")
        print("Fetching all the category budgets...")
        categoriesBudgetList = PersistenceController.shared.fetchCategoryBudgets(for: forBudget)
        print("Number of budgets: \(categoriesBudgetList.count)")
        categoriesBudgetTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedCategoryBudget = sender as? CategoryBudget else { return }
        
        if segue.identifier == "budgetDetails", let navController = segue.destination as? UINavigationController {
                if let destinationVC = navController.topViewController as? BudgetDetailsViewController {
                    destinationVC.selectedCategoryBudget = selectedCategoryBudget
                }
        }
    }
}

// MARK: - Table View Data Source and Delegate

extension BudgetsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesBudgetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let budgetCell = categoriesBudgetTableView.dequeueReusableCell(withIdentifier: "budgetCell") as? BudgetsTableViewCell else {
            return UITableViewCell()
        }
        
        budgetCell.update(with: categoriesBudgetList[indexPath.row])
        
        return budgetCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBudget = categoriesBudgetList[indexPath.row]
        print("Selected budget: \(selectedBudget.category.name)")
        self.performSegue(withIdentifier: "budgetDetails", sender: selectedBudget)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the category budget
            PersistenceController.shared.deleteCategoryBudget(categoryBudget: categoriesBudgetList[indexPath.row])
            PersistenceController.shared.saveContext()
            // Remove from the local list and update the table view
            categoriesBudgetList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}



