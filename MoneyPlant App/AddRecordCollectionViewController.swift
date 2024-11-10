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
            expenseCell?.cateogryNameLabel.text = expenseCategories[indexPath.row].name
            expenseCell?.categorySymbolLabel.image = expenseCategories[indexPath.row].symbol
            return expenseCell!
        }
        else{
            let incomeCell = incomeCategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "incomeCollectionViewCell", for: indexPath) as? AddRecordCollectionViewCell
            incomeCell!.cateogryNameLabel.text = incomeCategories[indexPath.row].name
            incomeCell!.categorySymbolLabel.image = incomeCategories[indexPath.row].symbol
            return incomeCell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == expenseCategoriesCollectionView{
            
            print("Selected Category: \(expenseCategories[indexPath.row].name)")
        }else{
            print("Selected Category: \(incomeCategories[indexPath.row].name)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90, height: 90)
        
    }
    
}
