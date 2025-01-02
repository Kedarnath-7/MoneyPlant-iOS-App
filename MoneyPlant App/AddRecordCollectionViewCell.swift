//
//  AddRecordCollectionViewCell.swift
//  MoneyPlant App
//
//  Created by admin86 on 06/11/24.
//

import UIKit

class AddRecordCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categorySymbolLabel: UIImageView!
    
    @IBOutlet weak var cateogryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with category: Category) {
        if !category.icon.isEmpty {
            categorySymbolLabel.image = UIImage(data: category.icon)
        } else {
            categorySymbolLabel.image = UIImage(systemName: "questionmark.circle")
        }

        cateogryNameLabel.text = category.name
    }
    

}
