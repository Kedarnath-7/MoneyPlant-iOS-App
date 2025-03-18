//
//  StoreCollectionViewCell.swift
//  SavingTransactions
//
//  Created by admin86 on 16/03/25.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var requiredCoinsButton: UIButton!
    
    func configure(image: UIImage, name: String, buttonTitle: String) {
        imageView.image = image
        nameLbl.text = name
        requiredCoinsButton.setTitle(buttonTitle, for: .normal)
    }
}

