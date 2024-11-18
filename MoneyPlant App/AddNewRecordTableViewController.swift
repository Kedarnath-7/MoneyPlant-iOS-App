//
//  AddNewRecordTableViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/11/24.
//

import UIKit

class AddNewRecordTableViewController: UITableViewController {
    
    var transaction: Transactions?
    var selectedCategory: Categories?
    var selectedExpenseCategory: Categories?
    var selectedIncomeCategory: Categories?
    
    @IBOutlet weak var selectedCategoryImage: UIImageView!

    @IBOutlet weak var selectedCategoryName: UITextField!
    
    @IBOutlet weak var selectedCategoryAmount: UITextField!
    
    @IBOutlet weak var selectedCategoryDate: UITextField!
    
    @IBOutlet weak var selectedCategoryNote: UITextField!
    
    @IBOutlet weak var saveRecordButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let expenceCategory = selectedExpenseCategory {
            selectedCategory = expenceCategory
            print("selectedExpenseCategory Data passed")
            selectedCategoryImage.image = expenceCategory.symbol
            navigationItem.title = "Add New Expense Record"
        }
         if let incomeCategory = selectedIncomeCategory {
             selectedCategory = incomeCategory
             print("selectedIncomeCategory Data passed")
             selectedCategoryImage.image = incomeCategory.symbol
             navigationItem.title = "Add New Income Record"
        }
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let categoryAmount = selectedCategoryAmount.text ?? ""
        let categoryDate = selectedCategoryDate.text ?? ""
        let categoryNote = selectedCategoryNote.text ?? ""
        saveRecordButton.isEnabled = !categoryAmount.isEmpty && !categoryDate.isEmpty && selectedCategoryImage.image != nil
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let destinationVC = segue.destination as! TransactionsViewController
        
        let name = selectedCategoryName?.text
        let category = selectedCategory?.name
        let image = selectedCategoryImage.image ?? nil
        let amount = selectedCategoryAmount.text ?? ""
        let date = selectedCategoryDate.text ?? ""
        let note = selectedCategoryNote.text ?? ""
        
        transaction = Transactions(symbol: image!, name: name!, amount: Double(amount)!, category: category!)
    }

    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCategoryImageCell", for: indexPath) as? AddNewRecordTableViewCell else{return UITableViewCell()}
//        
//        cell.
//        // Configure the cell...
//
//        return cell
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    
}
