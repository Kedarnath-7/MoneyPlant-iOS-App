//
//  pieChartViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 18/11/24.
//

import UIKit

class pieChartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pieChartContainerView: UIView!  // A UIView to hold the pie chart
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var bottomSheetView: UIView!

    @IBOutlet weak var bottomSheetHeightConstraint: NSLayoutConstraint! // Connect the height constraint of the bottom sheet
    @IBOutlet weak var highestButton: UIButton!
    
    @IBOutlet weak var lowestButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var graphContainerView: UIView!
    
    var graphView: UIView!
    
    var categoryData: [(name: String, value: Double, color: UIColor, symbol: UIImage)] = [
        ("Food", 500.0, .systemOrange, UIImage(systemName: "fork.knife.circle.fill")!),
        ("Fuel", 2500.0, .systemRed, UIImage(systemName: "fuelpump.circle.fill")!),
        ("Shopping", 1000.0, .systemBlue, UIImage(systemName: "bag.circle.fill")!),
        ("Service", 6000.0, .systemGreen, UIImage(systemName: "car.circle.fill")!)
    ]


       override func viewDidLoad() {
           super.viewDidLoad()
           super.viewDidLoad()
              setupPieChart()
              setupBottomSheet()
              setupGrabber()
              categoryTableView.delegate = self
              categoryTableView.dataSource = self
              bottomSheetHeightConstraint.constant = UIScreen.main.bounds.height
              view.layoutIfNeeded()

              // Initially show pie chart and hide graph
              pieChartContainerView.isHidden = false
              graphContainerView.isHidden = true

              setupGraph()
              pageControl.numberOfPages = 2
              pageControl.currentPage = 0
              pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
           let graphView = LineGraphView()
           graphView.backgroundColor = .green // Set background color

       }
       let collapsedHeight: CGFloat = 0 // Height when collapsed
       let expandedHeight: CGFloat = 544 // Height when expanded
       let grabberLayer = CALayer()
    
    
    @objc func pageControlChanged() {
        if pageControl.currentPage == 0 {
                // Show pie chart and hide graph
                pieChartContainerView.isHidden = false
                graphContainerView.isHidden = true
            } else {
                // Hide pie chart and show graph
                pieChartContainerView.isHidden = true
                graphContainerView.isHidden = false

                // Redraw the graph to ensure it's visible
                setupGraph()
            }
       }

       // MARK: - Graph View Setup
    func setupGraph() {
        // Remove any existing subviews to avoid overlap
        graphContainerView.subviews.forEach { $0.removeFromSuperview() }

          // Create the graph view
          let graphView = LineGraphView()
          graphView.dataPoints = [2000, 5000, 3000, 7000, 10000, 8000, 4000]
          graphView.labels = ["23 Mo", "24 Tu", "25 We", "26 Th", "27 Fr", "28 Sa", "29 Su"]

          // Set the frame of the graph view to match the container
          graphView.frame = graphContainerView.bounds
          graphView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

          // Add the graph view to the container
          graphContainerView.addSubview(graphView)
        print("Graph Container View Bounds: \(graphContainerView.bounds)") // Check if bounds are correct
        print("Graph Container View Subviews: \(graphContainerView.subviews)") // Ensure graphView is added
    }
   
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
            // Slide the bottom sheet up
        if bottomSheetHeightConstraint.constant == collapsedHeight {
                   expandBottomSheet()
               } else {
                   collapseBottomSheet()
               }
        }
        
        @IBAction func highestSortSelected(_ sender: UIButton) {
            // Sort the data by highest
            categoryData.sort { $0.value > $1.value }
            categoryTableView.reloadData()
            
            dismissBottomSheet()
        }

        @IBAction func lowestSortSelected(_ sender: UIButton) {
            // Sort the data by lowest
            categoryData.sort { $0.value < $1.value }
            categoryTableView.reloadData()
           
            dismissBottomSheet()
        }

        private func dismissBottomSheet() {
            // Slide the bottom sheet back down
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.bottomSheetView.frame.height)
            }
        }
    // MARK: - Bottom Sheet Behavior
       private func expandBottomSheet() {
           UIView.animate(withDuration: 0.3) {
               self.bottomSheetHeightConstraint.constant = self.expandedHeight
               self.view.layoutIfNeeded()
           }
       }

       private func collapseBottomSheet() {
           UIView.animate(withDuration: 0.3) {
               self.bottomSheetHeightConstraint.constant = self.collapsedHeight
               self.view.layoutIfNeeded()
           }
       }


        private func setupBottomSheet() {
            // Initially hide the bottom sheet below the visible area
            bottomSheetView.transform = CGAffineTransform(translationX: 0, y: bottomSheetView.frame.height)
            bottomSheetView.layer.cornerRadius = 30 // Optional: Make it rounded
            bottomSheetView.layer.masksToBounds = true
        }
    func setupGrabber() {
        // Configure the grabber layer
        grabberLayer.backgroundColor = UIColor.lightGray.cgColor
        grabberLayer.cornerRadius = 2.5
        grabberLayer.frame = CGRect(x: (bottomSheetView.bounds.width - 40) / 2, y: 8, width: 40, height: 5)
        bottomSheetView.layer.addSublayer(grabberLayer)
    }

       // MARK: - Pie Chart Setup
       func setupPieChart() {
           let totalValue = categoryData.reduce(0) { $0 + $1.value }
           var startAngle: CGFloat = -.pi / 2
           
           for category in categoryData {
               let percentage = CGFloat(category.value / totalValue)
               let endAngle = startAngle + (2 * .pi * percentage)
               
               let segmentLayer = CAShapeLayer()
               segmentLayer.fillColor = UIColor.clear.cgColor
               segmentLayer.strokeColor = category.color.cgColor
               segmentLayer.lineWidth = 40
               
               let center = CGPoint(x: pieChartContainerView.bounds.width / 2, y: pieChartContainerView.bounds.height / 2)
               let radius = min(pieChartContainerView.bounds.width, pieChartContainerView.bounds.height) / 3
               let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
               segmentLayer.path = path.cgPath
               pieChartContainerView.layer.addSublayer(segmentLayer)
               
               startAngle = endAngle
           }
           
           addCenterText(to: pieChartContainerView, text: "₹\(Int(totalValue))")
       }

       // MARK: - Table View Setup
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return categoryData.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
           let category = categoryData[indexPath.row]
           let totalValue = categoryData.reduce(0) { $0 + $1.value }
           
           // Configure the custom cell with category data and total value
           cell.configure(with: category, totalValue: totalValue)
           return cell
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80  // Adjust row height as needed
       }

       // MARK: - Helper Functions

       func addCenterText(to view: UIView, text: String) {
           let label = UILabel()
           label.text = text
           label.font = UIFont.boldSystemFont(ofSize: 18)
           label.textColor = .black
           label.textAlignment = .center
           
           label.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(label)
           
           NSLayoutConstraint.activate([
               label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ])
       }
   }