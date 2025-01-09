//
//  BudgetViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 31/12/24.
//

import UIKit

private let monthYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM yyyy"
    return formatter
}()

class BudgetsViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var noBudgetView: UIView!
    @IBOutlet weak var budgetsView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftChevronButton: UIButton!
    @IBOutlet weak var rightChevronButton: UIButton!
    
    @IBOutlet weak var totalIncomeLbl: UILabel!
    @IBOutlet weak var totalSpentLbl: UILabel!
    @IBOutlet weak var totalRemainingLbl: UILabel!
    @IBOutlet weak var AddOrEditBudget: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentMonth: Date = Date()
    var currentMonthBudget: Budget?
    var allCategoryBudgets: [CategoryBudget] = [] // Full list of budgets for the current month
    var filteredBudgets: [CategoryBudget] = []    // Filtered list for search results
    var isSearching: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        AddOrEditBudget.tintColor = .tintColor
        searchBar.delegate = self
        loadBudgets()
        updateForCurrentMonth()
    }

    // MARK: - Data Loading
    func loadBudgets() {
        currentMonthBudget = PersistenceController.shared.fetchBudget(for: monthYearFormatter.string(from: currentMonth))
        if currentMonthBudget != nil {
            print("Found total budget for \(monthYearFormatter.string(from: currentMonth)): \(currentMonthBudget!.budgetedAmount)")
            print("Fetching category budgets for \(monthYearFormatter.string(from: currentMonth)).")
            
            allCategoryBudgets = PersistenceController.shared.fetchCategoryBudgets(for: currentMonthBudget)
        }else{
            print("No total budget found for \(monthYearFormatter.string(from: currentMonth)).")
            print("Creating new budget for \(monthYearFormatter.string(from: currentMonth)) with default values.")
            currentMonthBudget = PersistenceController.shared.addBudget(income: totalIncome(), budgetAmount: 0.0, monthYear: monthYearFormatter.string(from: currentMonth))
            
            allCategoryBudgets = []
        }
        updateBudgetAmountLbl(for: currentMonthBudget!.budgetedAmount)
        
        filteredBudgets = allCategoryBudgets
    }

    // MARK: - UI Updates
    func updateForCurrentMonth() {
        if !isSearching {
            filteredBudgets = allCategoryBudgets
        }
        updateTableView()
        updateMonthLabel()
        updateChevronStates()
        updateFinancialSummary()
    }
    
    func updateBudgetAmountLbl(for budgetAmount: Double) {
        let title = String("₹\(budgetAmount)")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium)
        ]

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        AddOrEditBudget.setAttributedTitle(attributedTitle, for: .normal)
    }

    func updateTableView() {
        let hasBudgets = !filteredBudgets.isEmpty
        UIView.animate(withDuration: 0.3) {
            self.noBudgetView.isHidden = hasBudgets
            self.budgetsView.isHidden = !hasBudgets
        }
        if let containerVC = children.last as? BudgetsTableViewController {
            containerVC.forBudget = currentMonthBudget
            containerVC.categoriesBudgetList = filteredBudgets
            containerVC.categoriesBudgetTableView.reloadData()
        }
    }

    func updateMonthLabel() {
        monthLabel.text = monthYearFormatter.string(from: currentMonth)
    }

    func updateChevronStates() {
        let isCurrentMonth = Calendar.current.isDate(currentMonth, equalTo: Date(), toGranularity: .month)
        rightChevronButton.isEnabled = !isCurrentMonth
    }
    
    func totalIncome() -> Double {
        PersistenceController.shared.fetchTransactions()
            .filter { $0.type == "Income" && Calendar.current.isDate($0.date, equalTo: currentMonth, toGranularity: .month) }
            .reduce(0.0) { $0 + $1.amount }
    }
    
    func totalSpent() -> Double {
        PersistenceController.shared.fetchTransactions().filter{ $0.type == "Expense" && Calendar.current.isDate($0.date, equalTo: currentMonth, toGranularity: .month)}.reduce(0.0) { $0 + $1.amount}
    }
    
    func updateFinancialSummary() {
        let totalIncome = totalIncome()
        let totalSpent = totalSpent()
        let totalRemaining = currentMonthBudget!.budgetedAmount - totalSpent
        
        totalIncomeLbl.text = String(format: "₹ %.2f", totalIncome)
        totalSpentLbl.text = String(format: "₹ %.2f", totalSpent)
        totalRemainingLbl.text = String(format: "₹ %.2f", totalRemaining)
    }

    // MARK: - Month Navigation
    @IBAction func didTapLeftChevron(_ sender: UIButton) {
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) else { return }
        currentMonth = previousMonth
        loadBudgets()
        updateForCurrentMonth()
    }

    @IBAction func didTapRightChevron(_ sender: UIButton) {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) else { return }
        currentMonth = nextMonth
        loadBudgets()
        updateForCurrentMonth()
    }

    // MARK: - UISearchBarDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredBudgets = allCategoryBudgets
        } else {
            isSearching = true
            filteredBudgets = allCategoryBudgets.filter { budget in
                budget.category.name.lowercased().contains(searchText.lowercased()) ||
                String(format: "%.2f", budget.budgetedAmount).contains(searchText)
            }
        }
        updateTableView()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredBudgets = allCategoryBudgets
        updateTableView()
    }

    // MARK: - Add or Edit Budget
    @IBAction func didTapAddOrEditBudget(_ sender: UIButton) {
        let budget = PersistenceController.shared.fetchBudget(for: monthYearFormatter.string(from: currentMonth))
        print("fetched Budget for current month \(String(describing: budget?.budgetedAmount))")
        self.performSegue(withIdentifier: "AddOrEditBudgetSegue", sender: currentMonthBudget)
    }
    
    @IBAction func didTapAddNewCategoryBudget(_ sender: UIButton) {
        guard let budget = currentMonthBudget else {
            print("No budget found for the current month.")
            return
        }
        // Just ensure the current budget is available; segue will handle navigation.
        print("Budget to pass: \(budget)")
        performSegue(withIdentifier: "AddNewCategoryBudgetSegue", sender: currentMonthBudget)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let budget = sender as? Budget else { return }
        if segue.identifier == "AddOrEditBudgetSegue"{
            if let navController = segue.destination as? UINavigationController{
                if let destinationVC = navController.topViewController as? AddNewBudgetTableViewController {
                    
                    destinationVC.totalBudget = budget
                    print("Assignging total budget variable in AddNewBudgetTableViewController to current month(exisitng else nil) \(String(describing: destinationVC.totalBudget))")
                }
            }
        }else if segue.identifier == "AddNewCategoryBudgetSegue", let destinationVC = segue.destination as? CategoriesCollectionViewController {
            destinationVC.forBudget = currentMonthBudget
            print("destinationVC forBudget: \(String(describing: destinationVC.forBudget))")
        }
    }
    
    enum BudgetFilter {
        case exceeded
        case onTrack
        case amountRange(min: Double, max: Double?)
        case all
    }

    @IBAction func didTapFilterButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Filter Budgets", message: "Select a filter option", preferredStyle: .actionSheet)
        
        // Filter by progress
        alert.addAction(UIAlertAction(title: "Exceeded Budgets", style: .default, handler: { _ in
            self.filterBudgets(by: .exceeded)
        }))
        alert.addAction(UIAlertAction(title: "On Track", style: .default, handler: { _ in
            self.filterBudgets(by: .onTrack)
        }))
        
        // Filter by budget amount
        alert.addAction(UIAlertAction(title: "< ₹1000", style: .default, handler: { _ in
            self.filterBudgets(by: .amountRange(min: 0, max: 1000))
        }))
        alert.addAction(UIAlertAction(title: "₹1000 - ₹5000", style: .default, handler: { _ in
            self.filterBudgets(by: .amountRange(min: 1000, max: 5000))
        }))
        alert.addAction(UIAlertAction(title: "> ₹5000", style: .default, handler: { _ in
            self.filterBudgets(by: .amountRange(min: 5000, max: nil))
        }))
        
        // Show all budgets
        alert.addAction(UIAlertAction(title: "All", style: .default, handler: { _ in
            self.filterBudgets(by: .all)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    func filterBudgets(by filter: BudgetFilter) {
        switch filter {
        case .exceeded:
            // Budgets that are exceeded (actual expenses > budgeted amount)
            filteredBudgets = allCategoryBudgets.filter { $0.spentAmount > $0.budgetedAmount }
            
        case .onTrack:
            // Budgets that are within their limits
            filteredBudgets = allCategoryBudgets.filter {
                $0.spentAmount <= $0.budgetedAmount &&
                $0.budgetedAmount - $0.spentAmount > 0.2 * $0.budgetedAmount
            }
            
        case .amountRange(let min, let max):
            // Budgets within a specific amount range
            filteredBudgets = allCategoryBudgets.filter { budget in
                budget.budgetedAmount >= min && (max == nil || budget.budgetedAmount <= max!)
            }
            
        case .all:
            // Show all budgets
            filteredBudgets = allCategoryBudgets
        }
        
        // Reload the table view with the filtered data
        updateTableView()
    }

    
    @IBAction func unwindToBudgetsViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveBudget",
              let sourceVC = segue.source as? AddNewBudgetTableViewController else { return }
        
        if let totalBudget = sourceVC.totalBudget {
            // Save or update the total budget
            if let existingBudget = currentMonthBudget {
                    PersistenceController.shared.updateBudget(budget: existingBudget, income: totalBudget.totalIncome, budgetAmount: totalBudget.budgetedAmount, totalExpenses: nil)
            } else {
                let addedTotalBudget = PersistenceController.shared.addBudget(income: totalBudget.totalIncome, budgetAmount: totalBudget.budgetedAmount, monthYear: totalBudget.monthYear)
                print("Updated total budget: \(addedTotalBudget!.budgetedAmount)")
            }
            updateBudgetAmountLbl(for: totalBudget.budgetedAmount)
        }
        
        if let categoryBudget = sourceVC.existingCategoryBudget {
            if PersistenceController.shared.fetchCategoryBudgets(for: currentMonthBudget).contains(where: { $0.category == categoryBudget.category }){
                PersistenceController.shared.updateCategoryBudget(categoryBudget: categoryBudget, spentAmount: categoryBudget.spentAmount, budgetedAmount: categoryBudget.budgetedAmount)
            }else{
                let addedCategoryBudget = PersistenceController.shared.addCategoryBudget(for: categoryBudget.budget, category: categoryBudget.category, budgetedAmount: categoryBudget.budgetedAmount)
                print("Added category budget for \(addedCategoryBudget!.category.name): \(addedCategoryBudget!.budgetedAmount)")
            }
        }
        
        loadBudgets()
        updateForCurrentMonth()
    }
}
