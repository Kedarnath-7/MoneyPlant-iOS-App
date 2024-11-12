//
//  AddNewRecordViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 11/11/24.
//

import UIKit

class AddNewRecordViewController: UIViewController {
    
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var selectedExpenseCategory: Categories?
    var selectedIncomeCategory: Categories?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryImage.image = selectedExpenseCategory?.symbol
        categoryImage.image = selectedIncomeCategory?.symbol
        categoryNameLabel.text = selectedExpenseCategory?.name
        categoryNameLabel.text = selectedIncomeCategory?.name
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
