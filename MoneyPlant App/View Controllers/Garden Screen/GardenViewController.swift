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
    @IBOutlet weak var weeklyProgressCollectionView: UICollectionView!
    @IBOutlet weak var sceneKitView: SCNView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var totalAllocatedLabel: UILabel!
    @IBOutlet weak var totalSpentLabel: UILabel!
    @IBOutlet weak var remainingBudgetLabel: UILabel!
    @IBOutlet weak var plantStageLbl: UILabel!
    @IBOutlet weak var plantGrowth: VerticalProgressBarView!
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
        //setVisibleWeekIndex()
        loadBudgetsForMonth(date: selectedDate)
        //updateUIForVisibleWeek()
        finalizedPastWeeks = false
        finalizedPastMonths = false
        checkForWeeksAndMonthsFinalization()
        setupSceneKitView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateScene), name: NSNotification.Name("UpdateGardenScene"), object: nil)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeVC), userInfo: nil, repeats: false)
    }
    
    @objc func updateScene() {
        print("🔄 Garden screen updating environment & plant...")
        scene.rootNode.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
        setupSceneKitView()
    }
    
    @objc func changeVC(){
        let user = PersistenceController.shared.fetchUser()!
        if user.onBoardingRequired {
            user.onBoardingRequired = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
            vc.modalPresentationStyle = .automatic
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
        }
    }
        
    @IBAction func unwindToGardenViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "continueUnwind",
                  let _ = segue.source as? OnboardingViewController else{return}
        segue.source.modalPresentationStyle = .automatic
        segue.source.modalTransitionStyle = .coverVertical
    }

    func setupSceneKitView() {
        guard let budget = PersistenceController.shared.fetchBudget(for: formatDateToMonthYear(date: selectedDate)),
              let plant = budget.plant else {
            print("❌ No budget or plant found for the selected month.")
            return
        }

        let plantSpecie = plant.plantSpecie.name.isEmpty ? "Flower" : plant.plantSpecie.name
        let environment = plant.environment.name.isEmpty ? "Cliff_House" : plant.environment.name
        
        print("Plant Specie: \(plantSpecie), Environment: \(environment)")

        scene = SCNScene()
        sceneKitView.scene = scene
        sceneKitView.allowsCameraControl = true

        let environmentSceneName = "art.scnassets/\(environment).scn"
        print("🏡 Loading Environment: \(environmentSceneName)")

        if let newScene = SCNScene(named: environmentSceneName) {
            scene = newScene
            sceneKitView.scene = scene
        } else {
            print("❌ Failed to load environment: \(environmentSceneName)")
        }

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        updatePlantModel(for: plantSpecie, stage: plant.stage, environment: environment)
    }

    func updatePlantModel(for plantName: String, stage: String, environment: String) {
        guard let rootNode = scene?.rootNode else {
            print("❌ Scene root node is nil")
            return
        }

        rootNode.enumerateChildNodes { (node, _) in
            if node.name == plantName {
                node.removeFromParentNode()
            }
        }

        let plantSceneName = "art.scnassets/\(plantName)_\(stage).scn"
        print("🌱 Loading Plant: \(plantSceneName)")

        guard let plantScene = SCNScene(named: plantSceneName),
            let plantNode = plantScene.rootNode.childNode(withName: plantName, recursively: true) else {
            print("❌ Failed to load plant model: \(plantSceneName)")
            return
        }

        let plantScale: SCNVector3
        switch (plantName, environment) {
        case ("Tuple", "Mountain_House"): plantScale = SCNVector3(10, 10, 10) //Done
        case ("Tuple", "Low_Poly_Mill"): plantScale = SCNVector3(0.5, 0.5, 0.5) //Done
        case ("Tuple", "Low_Poly_House"): plantScale = SCNVector3(4, 4, 4) //Done
        case ("Tuple", "Cliff_House"): plantScale = SCNVector3(15, 15, 15) //Done
        case ("Tuple", "Forest_House"): plantScale = SCNVector3(0.75, 0.75, 0.75) //Done
        
        case ("Palm", "Mountain_House"): plantScale = SCNVector3(0.5, 0.5, 0.5) //Done
        case ("Palm", "Low_Poly_Mill"): plantScale = SCNVector3(0.03, 0.03, 0.03) //Done
        case ("Palm", "Low_Poly_House"): plantScale = SCNVector3(0.25, 0.25, 0.25) //Done
        case ("Palm", "Cliff_House"): plantScale = SCNVector3(1, 1, 1) //Done
        case ("Palm", "Forest_House"): plantScale = SCNVector3(0.05, 0.05, 0.05) //Done

        case ("Flower", "Mountain_House"): plantScale = SCNVector3(20, 20, 20) //Done
        case ("Flower", "Low_Poly_Mill"): plantScale = SCNVector3(1, 1, 1) //Done
        case ("Flower", "Low_Poly_House"): plantScale = SCNVector3(8, 8, 8) //Done
        case ("Flower", "Cliff_House"): plantScale = SCNVector3(40, 40, 40) //Done
        case ("Flower", "Forest_House"): plantScale = SCNVector3(2, 2, 2) //Done

        case ("Banana", "Mountain_House"): plantScale = SCNVector3(0.15, 0.15, 0.15) //Done
        case ("Banana", "Low_Poly_Mill"): plantScale = SCNVector3(0.006, 0.006, 0.006) //Done
        case ("Banana", "Low_Poly_House"): plantScale = SCNVector3(0.05, 0.05, 0.05) //Done
        case ("Banana", "Cliff_House"): plantScale = SCNVector3(0.25, 0.25, 0.25) //Done
        case ("Banana", "Forest_House"): plantScale = SCNVector3(0.01, 0.01, 0.01) //Done

        case ("Mushroom", "Mountain_House"): plantScale = SCNVector3(0.05, 0.05, 0.05) 
        case ("Mushroom", "Low_Poly_Mill"): plantScale = SCNVector3(0.007, 0.007, 0.007)
        case ("Mushroom", "Low_Poly_House"): plantScale = SCNVector3(0.07, 0.07, 0.07)
        case ("Mushroom", "Cliff_House"): plantScale = SCNVector3(0.05, 0.05, 0.05)
        case ("Mushroom", "Forest_House"): plantScale = SCNVector3(0.003, 0.003, 0.003)

        default:
            plantScale = SCNVector3(0.1, 0.1, 0.1)
        }
        
        let plantPosition: SCNVector3
        switch environment {
        case "Cliff_House": plantPosition = SCNVector3(2.389, 699.617, -227.645)
        case "Forest_House": plantPosition = SCNVector3(11.442, 1.479, -2.095)
        case "Mountain_House": plantPosition = SCNVector3(43.455, 272.453, 0.941)
        case "Low_Poly_Mill": plantPosition = SCNVector3(-2.175, 5.208, 0.155)
        case "Low_Poly_House": plantPosition = SCNVector3(0, 0, -15.134)
        default:
            plantPosition = SCNVector3(0, 0, 0)
        }
        
        plantNode.scale = plantScale
        plantNode.position = plantPosition
        
        print("Plant scale set to: \(plantScale), plant position set to: \(plantPosition)")
        
        scene.rootNode.addChildNode(plantNode)

        print("🌱 Updated plant model to: \(plantName) at stage: \(stage)")
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
            plantStageLbl.textColor = .black
        }
        weeklyProgressCollectionView.reloadData()
    }
    
    func updateWeekFinalization() {
        let today = Calendar.current.startOfDay(for: Date())
        let pastWeeks = PersistenceController.shared.fetchAllNotFinalizedWeeklyBudgets(date: today)

        print("Not finalized Weeks found: \(pastWeeks.count)")
        for week in pastWeeks where !week.isWeekFinalized {
            print("Week isWeekFinalized: \(week.isWeekFinalized), Week ID: \(week.id), week growth: \(week.weeklyGrowth)")
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
        print("Called updateGrowthProgress.....")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 1.0) {
                self.plantGrowth.progress = newProgress
                self.plantGrowthPercentageLbl.text = "\(Int(newProgress * 100))%"
            } completion: { _ in
                if let budget = PersistenceController.shared.fetchBudget(for: self.formatDateToMonthYear(date: self.selectedDate)),
                   let plant = budget.plant {
                    print("Updating plant model...")
                    self.updatePlantModel(for: plant.plantSpecie.name, stage: plant.stage, environment: plant.environment.name)
                }
            }
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
