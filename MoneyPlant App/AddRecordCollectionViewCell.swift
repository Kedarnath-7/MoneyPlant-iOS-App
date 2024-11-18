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
    
    func update(with category: Categories) {
        categorySymbolLabel.image = category.symbol
        cateogryNameLabel.text = category.name
    }
    

}
