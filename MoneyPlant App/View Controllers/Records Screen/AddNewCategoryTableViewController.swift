//
//  AddNewCategoryTableViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/11/24.
//

import UIKit

class AddNewCategoryTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var addNewCategory: Category?
    
    @IBOutlet weak var addNewCategoryLabel: UILabel!
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    @IBOutlet weak var categoryTypeTextField: UITextField!
    
    @IBOutlet weak var categoryIsRegular: UITextField!
    
    @IBOutlet weak var categoryDescriptionTextField: UITextField!
    
    @IBOutlet weak var saveNewCategoryButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let newCategory = addNewCategory {
            addNewCategoryLabel.text = "➕"
        }
        
        updateSaveButtonState()

    }
    
    func updateSaveButtonState() {
        let categoryNameText = categoryNameTextField.text ?? ""
        let categoryTypeText = categoryTypeTextField.text ?? ""
        saveNewCategoryButton.isEnabled = !categoryNameText.isEmpty && !categoryTypeText.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let id = UUID()
        let icon = addNewCategoryLabel.text ?? "❓"
        let name = categoryNameTextField.text ?? ""
        let type = categoryTypeTextField.text ?? ""
        _ = categoryIsRegular.text ?? ""
        let description = categoryDescriptionTextField.text ?? ""
        
        let addedNewCategory = PersistenceController.shared.addCategory(id: id, name: name, type: type, icon: icon, description: description)
        print("Added new category: \(addedNewCategory.name)")
    }
    
    
    @IBAction func addCoverTapped(_ sender: Any) {
        
    }
}
