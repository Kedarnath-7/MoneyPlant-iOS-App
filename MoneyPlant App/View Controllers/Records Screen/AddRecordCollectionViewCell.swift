//
//  AddRecordCollectionViewCell.swift
//  MoneyPlant App
//
//  Created by admin86 on 06/11/24.
//

import UIKit

class AddRecordCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categoryIconLabel: UILabel!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with category: Category) {
        categoryIconLabel.text = category.icon
        categoryNameLabel.text = category.name
    }
    

}
