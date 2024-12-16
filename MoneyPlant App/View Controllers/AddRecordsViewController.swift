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
        
        if sender.selectedSegmentIndex == 0 {
            addExpenseView.alpha = 1
            addIncomeView.alpha = 0
        } else {
            addExpenseView.alpha = 0
            addIncomeView.alpha = 1
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
