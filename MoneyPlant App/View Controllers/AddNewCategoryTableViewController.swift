//
//  AddNewCategoryTableViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/11/24.
//

import UIKit

class AddNewCategoryTableViewController: UITableViewController {
    
    var addNewCategory: Categories?
    
    @IBOutlet weak var addNewCategoryImage: UIImageView!
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    @IBOutlet weak var categoryTypeTextField: UITextField!
    
    @IBOutlet weak var categoryIsRegular: UITextField!
    
    @IBOutlet weak var categoryDescriptionTextField: UITextField!
    
    @IBOutlet weak var saveNewCategoryButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let newCategory = addNewCategory {
            addNewCategoryImage.image = newCategory.symbol
        }
        
        updateSaveButtonState()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateSaveButtonState() {
        let categoryNameText = categoryNameTextField.text ?? ""
        let categoryTypeText = categoryTypeTextField.text ?? ""
        let categoryIsRegularText = categoryIsRegular.text ?? ""
        let categoryDescritpionText = categoryDescriptionTextField.text ?? ""
        saveNewCategoryButton.isEnabled = !categoryNameText.isEmpty && !categoryTypeText.isEmpty && addNewCategoryImage.image != nil
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let destinationVC = segue.destination as! AddRecordCollectionViewController
        
        let image = addNewCategoryImage.image ?? UIImage(systemName: "plus")
        let name = categoryNameTextField.text ?? ""
        let type = categoryTypeTextField.text ?? ""
        let regular = categoryIsRegular.text ?? ""
        let description = categoryDescriptionTextField.text ?? ""
        
        addNewCategory = Categories(name: name, symbol: image!, type: type)
    }
    
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
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
