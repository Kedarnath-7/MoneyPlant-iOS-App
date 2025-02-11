//
//  ViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 20/12/24.
//

import UIKit
import SceneKit

class GardenViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weeklyProgressCollectionView: UICollectionView!
    @IBOutlet weak var sceneKitView: SCNView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var totalAllocatedLabel: UILabel!
    @IBOutlet weak var totalSpentLabel: UILabel!
    @IBOutlet weak var remainingBudgetLabel: UILabel!
    @IBOutlet weak var plantStageLbl: UILabel!
    @IBOutlet weak var plantGrowth: CircularProgressView!
    @IBOutlet weak var plantGrowthPercentageLbl: UILabel!
    @IBOutlet weak var editDailyLimitButton: UIButton!
    
    // MARK: - Variables
    var selectedDate: Date = Date()
    var weeklyBudgets: [WeeklyBudget] = []
    var visibleWeekStartIndex: Int = 0
    var scene: SCNScene!
    var finalizedPastWeeks: Bool = false
    var finalizedPastMonths: Bool = false
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentMonth = formatDateToMonthYear(date: Date())
        if finalizedPastWeeks && finalizedPastMonths && currentMonth == formatDateToMonthYear(date: selectedDate) {
            return
        }
        
        finalizedPastWeeks = false
        finalizedPastMonths = false
        checkForWeeksAndMonthsFinalization()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setVisibleWeekIndex()
        setupUI()
        setupBottomSheet()
        setupSceneKitView()
        loadBudgetsForMonth(date: selectedDate)
        updateUIForVisibleWeek()
    }

    // MARK: - Setup UI
    func setupUI() {
        if let layout = weeklyProgressCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 4
        }
    }
    
    func setupSceneKitView() {
        scene = SCNScene(named: "art.scnassets/Cliff_House.scn")
        sceneKitView.scene = scene
        sceneKitView.allowsCameraControl = true
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        if let budget = PersistenceController.shared.fetchBudget(for: formatDateToMonthYear(date: selectedDate)),
            let plant = budget.plant {
            updatePlantModel(for: plant.stage)
        }
    }
    
    func updatePlantModel(for stage: String) {
        scene.rootNode.childNode(withName: "plant", recursively: true)?.removeFromParentNode()
        
        guard let plantScene = SCNScene(named: "art.scnassets/\(stage).scn"),
              let plantNode = plantScene.rootNode.childNode(withName: "plant", recursively: true) else {
            print("❌ Failed to load plant model for stage: \(stage)")
            return
        }

        plantNode.position = SCNVector3(2.389, 699.617, -227.645)
//        plantNode.scale = SCNVector3(10, 10, 10)

        scene.rootNode.addChildNode(plantNode)

        print("🌱 Updated plant model to stage: \(stage)")
    }

    
    func setupBottomSheet() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBottomSheetPan))
        bottomSheetView.addGestureRecognizer(panGesture)
    }
    
    @objc func handleBottomSheetPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let newHeight = max(min(bottomSheetView.frame.height - translation.y, self.view.frame.height * 0.8), 100)
        bottomSheetView.frame.size.height = newHeight
        gesture.setTranslation(.zero, in: self.view)
    }
    
    // MARK: - Load Budgets
    func loadBudgetsForMonth(date: Date) {
        let monthYear = formatDateToMonthYear(date: date)
        if let budget = PersistenceController.shared.fetchBudget(for: monthYear) {
            weeklyBudgets = PersistenceController.shared.fetchWeeklyBudgets(for: budget)
        } else {
            weeklyBudgets = []
        }
        setVisibleWeekIndex()
        updateUIForVisibleWeek()
    }
    
    func setVisibleWeekIndex() {
        let calendar = Calendar.current
        let normalizedSelectedDate = calendar.startOfDay(for: selectedDate)

        if let weekIndex = weeklyBudgets.firstIndex(where: {
            let startOfWeek = calendar.startOfDay(for: $0.weekStartDate)
            let endOfWeek = calendar.startOfDay(for: $0.weekEndDate)
            return startOfWeek <= normalizedSelectedDate && endOfWeek >= normalizedSelectedDate
        }) {
            print("Found WeekIndex: \(weekIndex)")
            visibleWeekStartIndex = weekIndex
        } else {
            print("Week index not found... defaulting to 0")
            visibleWeekStartIndex = 0
        }
    }
    
    func updateUIForVisibleWeek() {
        guard !weeklyBudgets.isEmpty, visibleWeekStartIndex < weeklyBudgets.count else {
            print("❌ No weekly budgets available for this month.")
            totalAllocatedLabel.text = "₹ 0.00"
            totalSpentLabel.text = "₹ 0.00"
            remainingBudgetLabel.text = "₹ 0.00"
            updateGrowthProgress(to: 0.0)
            plantStageLbl.text = "Seedling"
            return
        }
        
        let currentWeek = weeklyBudgets[visibleWeekStartIndex]
        let (allocated, spent, remaining) = PersistenceController.shared.fetchWeeklySummary(for: currentWeek)
        
        totalAllocatedLabel.text = String(format: "₹ %.2f", allocated)
        totalSpentLabel.text = String(format: "₹ %.2f", spent)
        remainingBudgetLabel.text = String(format: "₹ %.2f", remaining)
        
        if let budget = PersistenceController.shared.fetchBudget(for: formatDateToMonthYear(date: selectedDate)) {
            let plant = PersistenceController.shared.fetchOrCreatePlant(for: budget)
            let progress = Float(plant.totalGrowth) / 100.0
            updateGrowthProgress(to: progress)
            plantStageLbl.text = plant.stage
        }
        weeklyProgressCollectionView.reloadData()
    }
    
    func updateWeekFinalization() {
        let today = Calendar.current.startOfDay(for: Date())
        let pastWeeks = PersistenceController.shared.fetchAllNotFinalizedWeeklyBudgets(date: today)

        for week in pastWeeks where !week.isWeekFinalized {
            week.isWeekFinalized = true
            PersistenceController.shared.updateWeeklyGrowth(for: week)
        }
        PersistenceController.shared.saveContext()
    }

    func updateMonthFinalization() {
        let today = Calendar.current.startOfDay(for: Date())
        let pastMonths = PersistenceController.shared.fetchAllNotFinalizedMonthlyBudgets(date: today)

        for month in pastMonths where !month.isMonthFinalized {
            month.isMonthFinalized = true
            PersistenceController.shared.updateMonthlyGrowth(for: month)
        }
        PersistenceController.shared.saveContext()
    }
    
    func checkForWeeksAndMonthsFinalization() {
        if !finalizedPastWeeks {
            finalizedPastWeeks = true
            updateWeekFinalization()
        }
        if !finalizedPastMonths {
            finalizedPastMonths = true
            updateMonthFinalization()
        }
    }
    
    func updateGrowthProgress(to newProgress: Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.plantGrowth.progress = newProgress
                self.plantGrowthPercentageLbl.text = "\(Int(newProgress * 100))%"
            }, completion: { _ in
                if let budget = PersistenceController.shared.fetchBudget(for: self.formatDateToMonthYear(date: self.selectedDate)),
                   let plant = budget.plant {
                    self.updatePlantModel(for: plant.stage)
                }
            })
        }
    }
    
    
    // MARK: - Actions
    @IBAction func didTapCalendarButton(_ sender: UIButton) {
        showMonthPicker()
    }
    
    @IBAction func didTapEditDailyLimitButton(_ sender: UIButton) {
        if let currentBudget = PersistenceController.shared.fetchBudget(for: formatDateToMonthYear(date: selectedDate)) {
            performSegue(withIdentifier: "ShowDailyAllocation", sender: currentBudget)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDailyAllocation",
           let destinationVC = segue.destination as? DailyAllocationViewController,
           let budget = sender as? Budget {
            destinationVC.budget = budget
        }
    }
    
    // MARK: - Helper Functions
    func getWeekForDate(_ date: Date, in weeklyBudgets: [WeeklyBudget]) -> WeeklyBudget? {
        for weeklyBudget in weeklyBudgets {
            let startDate = weeklyBudget.weekStartDate
            let endDate = weeklyBudget.weekEndDate
            if date >= startDate && date <= endDate {
                return weeklyBudget
            }
        }
        return nil
    }
    
    func getCurrentWeek(for date: Date) -> WeeklyBudget? {
        return getWeekForDate(date, in: weeklyBudgets)
    }
    
    func formatDateToMonthYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
    
    @objc func didSelectDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
        print("Selected Date: ", PersistenceController.shared.formatToLocalDate(selectedDate))
        loadBudgetsForMonth(date: selectedDate)
        setVisibleWeekIndex()
        updateUIForVisibleWeek()
    }
    
    func showMonthPicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = .current
        datePicker.date = selectedDate
        datePicker.locale = Locale(identifier: "en_IN_POSIX")
        datePicker.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
        
        let alert = UIAlertController(title: "Select Month", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(datePicker)
        datePicker.frame = CGRect(x: 0, y: 50, width: 270, height: 200)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            self.loadBudgetsForMonth(date: datePicker.date)
            self.updateUIForVisibleWeek()
        }))
        
        present(alert, animated: true)
    }
}

// MARK: - Collection View Delegate and Data Source
extension GardenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard visibleWeekStartIndex < weeklyBudgets.count else { return 0 }
        let currentWeek = weeklyBudgets[visibleWeekStartIndex]
        let daysInWeek = Calendar.current.dateComponents([.day], from: currentWeek.weekStartDate, to: currentWeek.weekEndDate).day ?? 6
        return daysInWeek + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCircleCell", for: indexPath) as? ProgressCircleCollectionViewCell else {
            return UICollectionViewCell()
        }

        let currentWeek = weeklyBudgets[visibleWeekStartIndex]
        if let date = Calendar.current.date(byAdding: .day, value: indexPath.item, to: currentWeek.weekStartDate) {
            let today = Calendar.current.startOfDay(for: Date())
            let isFutureDate = date > today

            if let dailyAllocation = PersistenceController.shared.fetchDailyAllocations(for: currentWeek).first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                print("Daily allocation found for date: \(PersistenceController.shared.formatToLocalDate(date)), growth: \(dailyAllocation.dailyGrowth)")
                let dailyGrowth = dailyAllocation.dailyGrowth
                cell.configure(dailyGrowth: dailyGrowth, maxGrowth: 3.0, day: formatDate(date: date), isFutureDate: isFutureDate)
            } else {
                cell.configure(dailyGrowth: 0.0, maxGrowth: 3.0, day: formatDate(date: date), isFutureDate: isFutureDate)
            }
        }
        return cell
    }
   
    func formatDate(date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return String(day)
    }
}

