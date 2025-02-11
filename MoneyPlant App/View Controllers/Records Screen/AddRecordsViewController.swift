//
//  AddRecordsViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 09/11/24.
//

import UIKit

class AddRecordsViewController: UIViewController {
    
    
    @IBOutlet weak var addExpenseView: UIView!
    
    @IBOutlet weak var addIncomeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addRecordSegementedControl(_ sender: UISegmentedControl) {
        addExpenseView.isHidden = sender.selectedSegmentIndex != 0
        addIncomeView.isHidden = sender.selectedSegmentIndex == 0
    }

}
