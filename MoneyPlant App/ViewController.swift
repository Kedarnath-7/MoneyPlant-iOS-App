//
//  ViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//

import UIKit

class ViewController: UIViewController{
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    lazy var bottomSheetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomVC") as? BottomSheetViewController
    
    //    @IBOutlet weak var bottomSheetView: UIView!
//    
//    @IBOutlet weak var bottomSheetHeightConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var taskTableView: UITableView!
//    
//    var originalHeight: CGFloat = 200
//       var expandedHeight: CGFloat = 650
//       let grabberLayer = CALayer() // Layer for the grabber
//       
//       // Sample Data for Daily Tasks
//       let tasks = [
//           ("Today", "Save Rs. 100"),
//           ("Yesterday", "Save Rs. 150"),
//           ("Sept 27, 2024", "Save Rs. 180"),
//           ("Sept 26, 2024", "Save Rs. 170"),
//           ("Sept 25, 2024", "Save Rs. 140"),
//           ("Sept 24, 2024", "Save Rs. 100"),
//           ("Sept 23, 2024", "Save Rs. 80")
//       ]
       
       override func viewDidLoad() {
           super.viewDidLoad()
           setUpElements()
           
//           setupBottomSheet()
//           setupGrabber()
//           setupTableView() // Initialize TableView
       }
    
    func setUpElements() {
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signUpButton)
    }
       
//       func setupBottomSheet() {
//           bottomSheetHeightConstraint.constant = originalHeight
//           bottomSheetView.layer.cornerRadius = 30 // Adjust as needed
//           bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//           bottomSheetView.clipsToBounds = true
//           // Add pan gesture recognizer
//           let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
//           bottomSheetView.addGestureRecognizer(panGesture)
//       }
//       
//       func setupGrabber() {
//           // Configure the grabber layer
//           grabberLayer.backgroundColor = UIColor.lightGray.cgColor
//           grabberLayer.cornerRadius = 2.5
//           grabberLayer.frame = CGRect(x: (bottomSheetView.bounds.width - 40) / 2, y: 8, width: 40, height: 5)
//           bottomSheetView.layer.addSublayer(grabberLayer)
//       }
//       
//       @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
//           let translation = recognizer.translation(in: self.view)
//           let newHeight = bottomSheetHeightConstraint.constant - translation.y
//
//           if newHeight >= originalHeight && newHeight <= expandedHeight {
//               bottomSheetHeightConstraint.constant = newHeight
//               recognizer.setTranslation(.zero, in: self.view)
//           }
//           
//           if recognizer.state == .ended {
//               let velocity = recognizer.velocity(in: self.view).y
//
//               UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
//                   if velocity > 0 {
//                       self.bottomSheetHeightConstraint.constant = self.originalHeight
//                   } else {
//                       self.bottomSheetHeightConstraint.constant = self.expandedHeight
//                   }
//                   self.view.layoutIfNeeded()
//               }, completion: nil)
//           }
//       }
//       
//       // MARK: - TableView Setup
//       func setupTableView() {
//           taskTableView.delegate = self
//           taskTableView.dataSource = self
//           taskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
//       }
//       
//       // MARK: - UITableView DataSource and Delegate
//       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//           return tasks.count
//       }
//
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
//           
//           let task = tasks[indexPath.row]
//           let dateText = task.0
//           let taskText = task.1
//           
//           // Configure the cell appearance
//           var content = cell.defaultContentConfiguration()
//           content.text = dateText
//           content.secondaryText = taskText
//           content.image = UIImage(systemName: "indianrupeesign.bank.building")
//           content.imageProperties.maximumSize = CGSize(width: 35, height: 35)
//           content.imageProperties.tintColor = .black
//           cell.contentConfiguration = content
//           cell.backgroundColor = UIColor.systemGray6
//           
//           return cell
//       }
    
}
