//
//  AddNewRecordViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 11/11/24.
//

import UIKit

class AddNewRecordViewController: UIViewController {
    
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var addNewRecordView: UIView!
    
    @IBOutlet weak var addNewCategoryView: UIView!
    
    
    var selectedExpenseCategory: Categories?
    var selectedIncomeCategory: Categories?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let expenceCategory = selectedExpenseCategory {
            categoryImage.image = expenceCategory.symbol
            addNewRecordView.alpha = 1
            addNewCategoryView.alpha = 0
        }
         if let incomeCategory = selectedIncomeCategory {
             categoryImage.image = incomeCategory.symbol
             addNewRecordView.alpha = 0
             addNewCategoryView.alpha = 1
        }
        
        navigationItem.title = "Add New Record"
        // Do any additional setup after loading the view.
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