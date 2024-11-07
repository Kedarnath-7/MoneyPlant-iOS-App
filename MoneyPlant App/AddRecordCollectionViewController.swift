//
//  AddRecordCollectionViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 06/11/24.
//

import UIKit

class AddRecordCollectionViewController: UIViewController {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension AddRecordCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? AddRecordCollectionViewCell else { return UICollectionViewCell() }
        
        cell.cateogryNameLabel.text = categories[indexPath.row].name
        cell.categorySymbolLabel.image = categories[indexPath.row].symbol
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Category: \(categories[indexPath.row].name)")
    }
    
}
