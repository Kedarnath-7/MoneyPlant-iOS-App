//
//  MonthOverviewViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 23/01/25.
//

import UIKit
import DGCharts

class InsightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    
    @IBOutlet weak var subMenuButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var selectedTimeFilter: String = "Monthly"
    var transactions: [Transaction] = []
    var groupedTransactions: [(category: Category, amount: Double)] = []
    var categoryColorMap: [String: UIColor] = [:]
    private var totalChartValue: Double = 0.0
    var selectedDate: Date = Date()
    
    let distinctColors: [UIColor] = [
        UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1),    // Green
        UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1),    // Red
        UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1),   // Blue
        UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1),    // Yellow
        UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1),   // Purple
        UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1),    // Orange
        UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1),    // Cyan
        UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1),    // Pink
        UIColor(red: 96/255, green: 125/255, blue: 139/255, alpha: 1),   // Blue Grey
        UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1),    // Indigo
        UIColor(red: 121/255, green: 85/255, blue: 72/255, alpha: 1),    // Brown
        UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1),    // Teal
        UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1),  // Grey
        UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1),    // Deep Orange
        UIColor(red: 3/255, green: 169/255, blue: 244/255, alpha: 1),    // Light Blue
        UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1),   // Light Green
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFilteredTransactions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createChartView()
        updateChartData()
    }
    
    func createChartView() {
        pieChartView.removeFromSuperview()
        
        let newChart = PieChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        newChart.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(newChart)
        
        NSLayoutConstraint.activate([
            newChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            newChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newChart.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        pieChartView = newChart
        setupPieChart()
    }
    
    func setupPieChart() {
        print("Setting up pie chart...")
        
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawHoleEnabled = true
        pieChartView.holeColor = .white
        pieChartView.holeRadiusPercent = 0.75
        pieChartView.transparentCircleRadiusPercent = 0.65
        
        pieChartView.drawEntryLabelsEnabled = false
        
        pieChartView.isUserInteractionEnabled = true
        pieChartView.highlightPerTapEnabled = true
        pieChartView.rotationEnabled = true
        
        pieChartView.delegate = self
        pieChartView.legend.enabled = false
        pieChartView.drawCenterTextEnabled = true // Enable center text
        pieChartView.centerText = "Total" // Default center text
        pieChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutCirc)

        print("Pie chart setup complete")
    }
    
    func fetchFilteredTransactions() {
        self.subMenuButton.setTitle(self.selectedTimeFilter, for: .normal)
        
        print("Fetching transactions with filter: \(selectedTimeFilter)")
        
        let isExpenseSelected = segmentedController.selectedSegmentIndex == 0
        transactions = PersistenceController.shared.fetchTransactions(for: selectedTimeFilter, selectedDate: selectedDate)
        let filterType = isExpenseSelected ? "Expense" : "Income"
        print("Filtering by type: \(filterType)")
        transactions = transactions.filter { isExpenseSelected ? $0.type == "Expense" : $0.type == "Income" }
        
        print("After filtering: \(transactions.count) transactions")
        
        groupTransactions()
        updateChartData()
        categoryTableView.reloadData()
    }
    
    func groupTransactions() {
        var categoryTotals: [Category: Double] = [:]
        
        for transaction in transactions {
            let category = transaction.category
            categoryTotals[category, default: 0] += transaction.amount
        }
        
        groupedTransactions = categoryTotals
            .map { (category, amount) in (category, amount) }
            .sorted { $0.amount > $1.amount } // Sort by amount (highest first)
        
        print("Grouped into \(groupedTransactions.count) categories")
        
        assignUniqueColorsToCategories()
    }
    
    func assignUniqueColorsToCategories() {
        categoryColorMap.removeAll()
        
        let uniqueCategories = Set(groupedTransactions.map { $0.category.name })
        
        for (index, category) in uniqueCategories.enumerated() {
            let colorIndex = index % distinctColors.count
            categoryColorMap[category] = distinctColors[colorIndex]
        }
        
        print("Assigned \(categoryColorMap.count) unique colors to categories")
    }

    func updateChartData() {
        print("Updating chart data...")
        
        var categoryTotals: [String: Double] = [:]
        for transaction in transactions {
            let category = transaction.category.name
            categoryTotals[category, default: 0] += transaction.amount
        }
        
        if categoryTotals.isEmpty {
            pieChartView.data = nil
            pieChartView.centerText = "No data available"
            return
        }
        
        var entries: [PieChartDataEntry] = []
        var dataSetColors: [UIColor] = []
        
        for (category, amount) in categoryTotals {
            entries.append(PieChartDataEntry(value: amount, label: category))
            
            if let color = categoryColorMap[category] {
                dataSetColors.append(color)
            } else {
                dataSetColors.append(.gray)
            }
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = dataSetColors
        
        dataSet.sliceSpace = 1
        dataSet.selectionShift = 8
        dataSet.valueLineColor = .clear
        dataSet.valueTextColor = .clear
        dataSet.entryLabelColor = .clear
        
        dataSet.automaticallyDisableSliceSpacing = false
        dataSet.yValuePosition = .outsideSlice
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.4
        
        let data = PieChartData(dataSet: dataSet)
        data.setDrawValues(false)
        
        pieChartView.data = data
        pieChartView.highlightValues(nil)
        
        self.totalChartValue = entries.reduce(0) { $0 + $1.value }
            
        let totalAmount = String(format: "₹%.2f", totalChartValue)
        let totalText = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        totalText.append(NSAttributedString(
        string: "Total\n",
        attributes: [.font: UIFont.systemFont(ofSize: 22), .paragraphStyle: paragraphStyle]
        ))
        totalText.append(NSAttributedString(
            string: totalAmount,
            attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .medium), .paragraphStyle: paragraphStyle]
        ))
        pieChartView.centerAttributedText = totalText
        
        print("Pie chart updated with \(entries.count) entries using unique colors")
    }

    // MARK: - 🟠 Handle Time Range Selection (Weekly, Monthly, Yearly)
    @IBAction func subMenuButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Time Range", message: nil, preferredStyle: .actionSheet)
        
        let weekly = UIAlertAction(title: "Weekly", style: .default) { _ in
            self.selectedTimeFilter = "Weekly"
            self.fetchFilteredTransactions()
        }
        
        let monthly = UIAlertAction(title: "Monthly", style: .default) { _ in
            self.selectedTimeFilter = "Monthly"
            self.fetchFilteredTransactions()
        }
        
        let yearly = UIAlertAction(title: "Yearly", style: .default) { _ in
            self.selectedTimeFilter = "Yearly"
            self.fetchFilteredTransactions()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(weekly)
        alert.addAction(monthly)
        alert.addAction(yearly)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - 🟢 Handle Date Selection (Calendar Button)
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = .current
        datePicker.date = selectedDate
        datePicker.locale = Locale(identifier: "en_IN_POSIX")
        datePicker.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)

        let alert = UIAlertController(title: "Select Date", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        datePicker.frame = CGRect(x: 0, y: 50, width: 270, height: 200)
        alert.view.addSubview(datePicker)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            self.selectedDate = datePicker.date
            self.fetchFilteredTransactions()
            self.updateCalendarButtonTitle()
        }))

        present(alert, animated: true)
    }

    @objc func didSelectDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
        fetchFilteredTransactions()
        updateCalendarButtonTitle()
    }
    
    func updateCalendarButtonTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_IN_POSIX")
        let dateString = dateFormatter.string(from: selectedDate)
        calendarButton.setTitle(dateString, for: .normal)
    }

    
    // MARK: - 🔴 Handle Expense/Income Toggle
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        fetchFilteredTransactions()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedTransactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? InsightsTableViewCell else {
            return UITableViewCell()
        }
        
        let transaction = groupedTransactions[indexPath.row]
        
        let categoryName = transaction.category.name
        let categoryAmount = transaction.amount
        let categoryIcon = transaction.category.icon
        let totalSpending = groupedTransactions.reduce(0) { $0 + $1.amount }
        
        let progress = totalSpending > 0 ? categoryAmount / totalSpending : 0

        let progressColor = categoryColorMap[categoryName] ?? .systemBlue
        
        cell.configure(icon: categoryIcon, name: categoryName, amount: categoryAmount, progress: progress)
        cell.progressViewOutlet.progressTintColor = progressColor

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    // MARK: - Chart Delegate Methods
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Chart value selected method called!")
        if let pieEntry = entry as? PieChartDataEntry, let pieChart = chartView as? PieChartView {
            let categoryName = pieEntry.label ?? "Unknown"
            let categoryValue = pieEntry.value
            
            let percentage = totalChartValue > 0 ? (categoryValue / totalChartValue) * 100 : 0
            let centerText = NSMutableAttributedString()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            centerText.append(NSAttributedString(
                string: categoryName + "\n",
                attributes: [.font: UIFont.systemFont(ofSize: 20), .paragraphStyle: paragraphStyle]
            ))
            
            // Add percentage with regular font
            centerText.append(NSAttributedString(
                string: String(format: "%.1f%%", percentage),
                attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .medium), .paragraphStyle: paragraphStyle]
            ))
            
            // Set the center text
            pieChart.centerAttributedText = centerText
            
            print("Selected category: \(categoryName) - Amount: \(categoryValue) - Percentage: \(percentage)%")
        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let pieChart = chartView as? PieChartView {
            
            let totalAmount = String(format: "₹%.2f", totalChartValue)
            let totalText = NSMutableAttributedString()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            totalText.append(NSAttributedString(
                string: "Total\n",
                attributes: [.font: UIFont.systemFont(ofSize: 22), .paragraphStyle: paragraphStyle]
            ))
            totalText.append(NSAttributedString(
                string: totalAmount,
                attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .medium), .paragraphStyle: paragraphStyle]
            ))
            pieChart.centerAttributedText = totalText
        }
    }
}
