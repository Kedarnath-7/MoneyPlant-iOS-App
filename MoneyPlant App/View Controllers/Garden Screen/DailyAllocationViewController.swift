//
//  DailyAllocationViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 16/01/25.
//

import UIKit

class DailyAllocationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var spentProgressView: CircularProgressView!
    @IBOutlet weak var remainingProgressView: CircularProgressView!
    @IBOutlet weak var weeksSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weekSummaryView: UIView!
    @IBOutlet weak var totalAllocatedButton: UIButton!
    @IBOutlet weak var totalSpentLabel: UILabel!
    @IBOutlet weak var remainingBudgetLabel: UILabel!
    
    // MARK: - Variables
    var budget: Budget? // Passed from GardenViewController
    var weeklyBudgets: [WeeklyBudget] = [] // Array of weekly budgets for the selected month
    var selectedWeeklyBudget: WeeklyBudget? // Currently selected weekly budget
    var dailyAllocations: [DailyAllocation] = [] // Store daily allocation data for the selected week
    
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
        tableView.tableFooterView = UIView() // Remove extra separators
        loadSegmentControl()
    }
    
    func loadSegmentControl() {
        weeksSegmentControl.removeAllSegments()
        for (index, budget) in weeklyBudgets.enumerated() {
            let weekLabel = "Week \(index + 1)"
            weeksSegmentControl.insertSegment(withTitle: weekLabel, at: index, animated: false)
        }
        if !weeklyBudgets.isEmpty {
            weeksSegmentControl.selectedSegmentIndex = 0
            selectedWeeklyBudget = weeklyBudgets[0]
            loadDailyAllocations()
            updateWeekSummary()
        } else {
            selectedWeeklyBudget = nil
            dailyAllocations = []
            tableView.reloadData()
            updateWeekSummary()
        }
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard selectedIndex < weeklyBudgets.count else { return }
        selectedWeeklyBudget = weeklyBudgets[selectedIndex]
        loadDailyAllocations()
        updateWeekSummary()
    }
    
    func updateWeekSummary() {
        guard let budget = selectedWeeklyBudget else {
            totalAllocatedButton.setTitle("₹ 0.00", for: .normal)
            totalSpentLabel.text = "₹ 0.00"
            remainingBudgetLabel.text = "₹ 0.00"
            spentProgressView.progress = 0.0
            remainingProgressView.progress = 0.0
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
        dailyAllocations.sort { ($0.date) < ($1.date) }
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
    
    // MARK: - Save Updated Allocations
    func saveUpdatedAllocations() {
        for allocation in dailyAllocations {
            PersistenceController.shared.updateDailyAllocation(
                dailyAllocation: allocation,
                spentAmount: allocation.spentAmount,
                allocatedAmount: allocation.allocatedAmount
            )
        }
        loadDailyAllocations() // Refresh the data
    }
    
    @IBAction func didTapTotalAllocatedButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit Weekly Budget", message: "Enter the new budget amount", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .decimalPad
            textField.placeholder = "₹ \(self.selectedWeeklyBudget?.allocatedAmount ?? 0)"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let newAmountString = alert.textFields?.first?.text, let newAmount = Double(newAmountString), newAmount >= 0 else {
                print("Invalid input")
                return
            }
            self?.updateWeeklyBudgetAmount(newAmount)
            self?.loadDailyAllocations()
            self?.updateWeekSummary()
        }))
        present(alert, animated: true, completion: nil)
    }

    func updateWeeklyBudgetAmount(_ newAmount: Double) {
        guard let budget = selectedWeeklyBudget else { return }
        PersistenceController.shared.updateWeeklyAllocation(for: budget, newAmount: newAmount)
        updateWeekSummary()
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
        cell.configure(with: allocation, isEditable: isDateEditable(allocation.date))
        cell.onAllocationChanged = { [weak self] newAmount in
            self?.dailyAllocations[indexPath.row].allocatedAmount = newAmount
            self?.updateWeekSummary()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    private func isDateEditable(_ date: Date) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return date >= today
    }
}
