//
//  DailyAllocationViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 16/01/25.
//

import UIKit

class DailyAllocationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var monthlyProgressView: UIProgressView!
    @IBOutlet weak var monthlyRemainingLabel: UILabel!
    @IBOutlet weak var spentProgressView: CircularProgressView!
    @IBOutlet weak var remainingProgressView: CircularProgressView!
    @IBOutlet weak var weeksSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weekSummaryView: UIView!
    @IBOutlet weak var totalAllocatedButton: UIButton!
    @IBOutlet weak var totalSpentLabel: UILabel!
    @IBOutlet weak var remainingBudgetLabel: UILabel!
    @IBOutlet weak var weeklyLockButton: UIButton!
    
    // MARK: - Variables
    var budget: Budget?
    var weeklyBudgets: [WeeklyBudget] = []
    var selectedWeeklyBudget: WeeklyBudget?
    var dailyAllocations: [DailyAllocation] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWeeklyBudgets()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        weekSummaryView.layer.cornerRadius = 10
        weekSummaryView.clipsToBounds = true
        tableView.tableFooterView = UIView()
        monthlyProgressView.progress = 0.0
        setupWeeklyLockButton()
        loadSegmentControl()
    }
    
    func setupWeeklyLockButton() {
        weeklyLockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
        weeklyLockButton.setImage(UIImage(systemName: "lock.fill"), for: .selected)
        weeklyLockButton.addTarget(self, action: #selector(toggleWeeklyLock(_:)), for: .touchUpInside)
    }
    
    func loadSegmentControl() {
        weeksSegmentControl.removeAllSegments()
        for (index, _) in weeklyBudgets.enumerated() {
            let weekLabel = "Week \(index + 1)"
            weeksSegmentControl.insertSegment(withTitle: weekLabel, at: index, animated: false)
        }
        if !weeklyBudgets.isEmpty {
            weeksSegmentControl.selectedSegmentIndex = 0
            selectedWeeklyBudget = weeklyBudgets[0]
            loadDailyAllocations()
            updateWeekSummary()
            updateMonthlySummary()
        } else {
            selectedWeeklyBudget = nil
            dailyAllocations = []
            tableView.reloadData()
            updateWeekSummary()
            updateMonthlySummary()
        }
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard selectedIndex < weeklyBudgets.count else { return }
        selectedWeeklyBudget = weeklyBudgets[selectedIndex]
        
        loadDailyAllocations()
        updateWeekSummary()
        updateMonthlySummary()
    }
    
    private func isWeekEditable(_ weeklyBudget: WeeklyBudget?) -> Bool {
        guard let weeklyBudget = weeklyBudget else { return false }
        let today = Calendar.current.startOfDay(for: Date())
        return weeklyBudget.weekEndDate >= today
    }
    
    private func isDateEditable(_ date: Date) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return date >= today
    }
    
    private func showWarning(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateWeekSummary() {
        guard let budget = selectedWeeklyBudget else {
            totalAllocatedButton.setTitle("₹ 0.00", for: .normal)
            totalSpentLabel.text = "₹ 0.00"
            remainingBudgetLabel.text = "₹ 0.00"
            spentProgressView.progress = 0.0
            remainingProgressView.progress = 0.0
            weeklyLockButton.isSelected = false
            weeklyLockButton.isEnabled = false
            weekSummaryView.layer.borderWidth = 0
            return
        }
        let allocated = budget.allocatedAmount
        let spent = budget.spentAmount
        let remaining = allocated - spent
        
        totalAllocatedButton.setTitle(String(format: "₹ %.2f", allocated), for: .normal)
        totalSpentLabel.text = String(format: "₹ %.2f", spent)
        remainingBudgetLabel.text = String(format: "₹ %.2f", remaining)
        
        spentProgressView.progress = Float(spent / max(allocated, 1.0))
        remainingProgressView.progress = Float(remaining / max(allocated, 1.0))
        
        weeklyLockButton.isSelected = budget.isLocked
        weeklyLockButton.isEnabled = isWeekEditable(budget)
        weekSummaryView.layer.borderWidth = budget.isLocked ? 2.0 : 0
        weekSummaryView.layer.borderColor = budget.isLocked ? UIColor.gray.cgColor : nil
    }
    
    func updateMonthlySummary() {
        guard let budget = budget else {
            monthlyProgressView.progress = 0.0
            monthlyRemainingLabel.text = "₹ 0.00"
            return
        }
        let (allocated, spent, remaining) = PersistenceController.shared.fetchMonthlySummary(for: budget)
        monthlyProgressView.progress = Float(spent / max(allocated, 1.0))
        monthlyRemainingLabel.text = String(format: "₹ %.2f left", remaining)
    }
    
    // MARK: - Load Data
    func loadWeeklyBudgets() {
        guard let budget = budget else {
            weeklyBudgets = []
            loadSegmentControl()
            return
        }
        weeklyBudgets = PersistenceController.shared.fetchWeeklyBudgets(for: budget)
        loadSegmentControl()
    }
    
    func loadDailyAllocations() {
        guard let weeklyBudget = selectedWeeklyBudget else {
            dailyAllocations = []
            tableView.reloadData()
            return
        }
        dailyAllocations = PersistenceController.shared.fetchDailyAllocations(for: weeklyBudget)
        let allTransactions = PersistenceController.shared.fetchTransactions(
            weekStartDate: weeklyBudget.weekStartDate,
            weekEndDate: weeklyBudget.weekEndDate)
        
        dailyAllocations.forEach { allocation in
            allocation.spentAmount = allTransactions
                .filter { Calendar.current.isDate($0.date, inSameDayAs: allocation.date) }
                .reduce(0.0) { $0 + $1.amount }
        }
        print("dailyallocations count: " + String(dailyAllocations.count))
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func didTapTotalAllocatedButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit Weekly Budget", message: "Enter the new budget amount", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .decimalPad
            textField.placeholder = "₹ \(self.selectedWeeklyBudget?.allocatedAmount ?? 0)"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let self = self,
                  let newAmountString = alert.textFields?.first?.text,
                  let newAmount = Double(newAmountString),
                  newAmount >= 0 else {
                self?.showWarning(message: "Invalid input. Please enter a non-negative number.")
                return
            }
            
            // Check if the new amount can accommodate locked daily allocations
            let dailyAllocations = self.dailyAllocations
            let lockedTotal = dailyAllocations.filter({ $0.isLocked }).reduce(0.0) { $0 + $1.allocatedAmount }
            if newAmount < lockedTotal {
                self.showWarning(message: "Cannot reduce the weekly budget below ₹\(String(format: "%.2f", lockedTotal)) because of locked daily allocations. Please unlock some days or reduce their amounts.")
                return
            }
            
            // Calculate new total of weekly budgets
            let otherWeeksTotal = self.weeklyBudgets
                .filter { $0 != self.selectedWeeklyBudget }
                .reduce(0.0) { $0 + $1.allocatedAmount }
            let newTotal = otherWeeksTotal + newAmount
            
            // Check if the new total exceeds the monthly budget
            guard let monthlyBudget = self.budget else { return }
            if newTotal > monthlyBudget.budgetedAmount {
                let alert = UIAlertController(title: "Exceeds Monthly Budget", message: "The new weekly budget will cause the total to exceed the monthly budget of ₹\(String(format: "%.2f", monthlyBudget.budgetedAmount)). What would you like to do?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Increase Monthly Budget", style: .default, handler: { _ in
                    // Navigate to BudgetsViewController to edit monthly budget
                    // This assumes you have a navigation controller and BudgetsViewController
                    // You'll need to implement this navigation based on your app's structure
                    self.showWarning(message: "Please navigate to the Budgets screen to increase the monthly budget.")
                }))
                alert.addAction(UIAlertAction(title: "Redistribute", style: .default, handler: { _ in
                    self.updateWeeklyBudgetAmount(newAmount)
                    PersistenceController.shared.redistributeWeeklyBudgets(for: monthlyBudget)
                    self.loadWeeklyBudgets()
                    self.updateWeekSummary()
                    self.updateMonthlySummary()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.updateWeeklyBudgetAmount(newAmount)
                self.loadDailyAllocations()
                self.updateWeekSummary()
                self.updateMonthlySummary()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func toggleWeeklyLock(_ sender: UIButton) {
        guard let budget = selectedWeeklyBudget else { return }
        sender.isSelected.toggle()
        budget.isLocked = sender.isSelected
        PersistenceController.shared.saveContext()
        updateWeekSummary()
    }
    
    func updateWeeklyBudgetAmount(_ newAmount: Double) {
        guard let budget = selectedWeeklyBudget else { return }
        PersistenceController.shared.updateWeeklyAllocation(for: budget, newAmount: newAmount)
    }
}

// MARK: - Table View Delegate and Data Source
extension DailyAllocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyAllocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyAllocationCell", for: indexPath) as? DailyAllocationTableViewCell else {
            return UITableViewCell()
        }
        let allocation = dailyAllocations[indexPath.row]
        
        // Determine if the text field should be enabled
        let otherAllocations = dailyAllocations.filter { $0 != allocation }
        let allOthersLocked = otherAllocations.allSatisfy { $0.isLocked }
        let weeklyTotal = selectedWeeklyBudget?.allocatedAmount ?? 0.0
        let currentTotal = dailyAllocations.reduce(0.0) { $0 + $1.allocatedAmount }
        let isInputEnabled = !(allOthersLocked && currentTotal >= weeklyTotal)
        
        cell.configure(with: allocation, isEditable: isDateEditable(allocation.date), isInputEnabled: isInputEnabled)
        
        cell.onAllocationChanged = { [weak self] newAmount in
            guard let self = self else { return }
            let totalDailyBudget = self.dailyAllocations.reduce(0.0) { $0 + $1.allocatedAmount }
            if let weeklyBudget = self.selectedWeeklyBudget, totalDailyBudget > weeklyBudget.allocatedAmount {
                let alert = UIAlertController(title: "Exceeds Weekly Budget", message: "The new daily allocation will exceed the weekly budget of ₹\(String(format: "%.2f", weeklyBudget.allocatedAmount)). What would you like to do?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Increase Weekly Budget", style: .default, handler: { _ in
                    self.didTapTotalAllocatedButton(self.totalAllocatedButton)
                }))
                alert.addAction(UIAlertAction(title: "Redistribute", style: .default, handler: { _ in
                    PersistenceController.shared.redistributeDailyBudgets(for: weeklyBudget)
                    self.loadDailyAllocations()
                    self.updateWeekSummary()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    self.loadDailyAllocations() // Revert changes
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                PersistenceController.shared.redistributeDailyBudgets(for: selectedWeeklyBudget!)
                self.loadDailyAllocations()
                self.updateWeekSummary()
            }
        }
        
        cell.onLockToggled = { [weak self] isLocked in
            guard let self = self else { return }
            // Reload the table to update the enabled state of text fields
            self.tableView.reloadData()
            // If all other allocations are now locked, check if we need to show a warning
            let otherAllocations = self.dailyAllocations.filter { $0 != allocation }
            let allOthersLocked = otherAllocations.allSatisfy { $0.isLocked }
            let weeklyTotal = self.selectedWeeklyBudget?.allocatedAmount ?? 0.0
            let currentTotal = self.dailyAllocations.reduce(0.0) { $0 + $1.allocatedAmount }
            if allOthersLocked && currentTotal > weeklyTotal {
                self.showWarning(message: "Cannot increase this allocation because all other days are locked, and the weekly budget limit is reached. Please unlock another day or increase the weekly budget.")
                // Revert the lock state to prevent invalid state
                allocation.isLocked = false
                PersistenceController.shared.saveContext()
                self.tableView.reloadData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}
