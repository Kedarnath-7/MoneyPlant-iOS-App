//
//  AddRecordCollectionViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 06/11/24.
//

import UIKit

class AddRecordCollectionViewController: UIViewController {
    
    @IBOutlet weak var expenseCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var incomeCategoriesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedCategory = sender as? Categories else { return }
        if segue.identifier == "addNewExpenseRecord" || segue.identifier == "addNewIncomeRecord"{
            if let navController = segue.destination as? UINavigationController {
                if let addVC = navController.topViewController as? AddNewRecordTableViewController {
                    if segue.identifier == "addNewExpenseRecord" {
                        addVC.selectedExpenseCategory = selectedCategory
                    }else if segue.identifier == "addNewIncomeRecord" {
                        addVC.selectedIncomeCategory = selectedCategory
                    }
                }
            }
        }else if segue.identifier == "addNewExpenseCategory" || segue.identifier == "addNewIncomeCategory" {
            if let navController = segue.destination as? UINavigationController {
                if let addVC = navController.topViewController as? AddNewCategoryTableViewController {
                    addVC.addNewCategory = selectedCategory
                }
            }
        }
        
    }
    
    @IBAction func unwindToCategoriesCollectionView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
                  let sourceViewController = segue.source as? AddNewCategoryTableViewController,
                  let category = sourceViewController.addNewCategory else { return }
        
            if category.type == "Expense"{
                expenseCategories.insert(category, at: expenseCategories.count - 1)
                let newIndexPath = IndexPath(row: expenseCategories.count - 2, section: 0)
                print("Inserting new item at indexPath: \(newIndexPath)")
                 
                if let collectionView = expenseCategoriesCollectionView {
                    collectionView.reloadData()
                    
                } else {
                    print("expenseCategoriesCollectionView is nil!")
                }
                print("New Expense Category Inserted: \(category.name)")
                
            }else{
                incomeCategories.insert(category, at: incomeCategories.count - 1)
                
                let newIndexPath = IndexPath(row: incomeCategories.count - 2, section: 0)

                print("Inserting new item at indexPath: \(newIndexPath)")
                
                if let collectionView = incomeCategoriesCollectionView {
                    collectionView.reloadData()
                } else {
                    print("incomeCategoriesCollectionView is nil!")
                }
                print("New Income Category Inserted: \(category.name)")
                
            }
    }
}

extension AddRecordCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == expenseCategoriesCollectionView {
            return expenseCategories.count
        }else{
            return incomeCategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == expenseCategoriesCollectionView{
            let expenseCell = expenseCategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "expenseCollectionViewCell", for: indexPath) as? AddRecordCollectionViewCell
            let expenseCategory = expenseCategories[indexPath.item]
            expenseCell?.update(with: expenseCategory)
//            expenseCell?.cateogryNameLabel.text = expenseCategories[indexPath.row].name
//            expenseCell?.categorySymbolLabel.image = expenseCategories[indexPath.row].symbol
            return expenseCell!
        }
        else{
            let incomeCell = incomeCategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "incomeCollectionViewCell", for: indexPath) as? AddRecordCollectionViewCell
            let incomeCategory = incomeCategories[indexPath.item]
            incomeCell?.update(with: incomeCategory)
//            incomeCell!.cateogryNameLabel.text = incomeCategories[indexPath.row].name
//            incomeCell!.categorySymbolLabel.image = incomeCategories[indexPath.row].symbol
            return incomeCell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == expenseCategoriesCollectionView{
            let selectedExpenseCategory = expenseCategories[indexPath.row]
            if selectedExpenseCategory.name == "Add New"{
                self.performSegue(withIdentifier: "addNewExpenseCategory", sender: selectedExpenseCategory)
                print("Add New Expense Category Cell Clicked")
            }else{
                print("Selected Expense Category: \(selectedExpenseCategory.name)")
                self.performSegue(withIdentifier: "addNewExpenseRecord", sender:  selectedExpenseCategory)
            }
            
        }else if collectionView == incomeCategoriesCollectionView {
            let selectedIncomeCategory = incomeCategories[indexPath.row]
            if selectedIncomeCategory.name == "Add New"{
                self.performSegue(withIdentifier: "addNewIncomeCategory", sender: selectedIncomeCategory)
                print("Add New Income Category Cell Clicked")
            }else{
                self.performSegue(withIdentifier: "addNewIncomeRecord", sender: selectedIncomeCategory)
                print("Selected Income Category: \(selectedIncomeCategory.name)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90, height: 90)
        
    }
    
    
}
