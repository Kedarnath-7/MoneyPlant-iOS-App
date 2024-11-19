//
//  OnboardingCollectionViewCell.swift
//  MoneyPlant App
//
//  Created by admin86 on 19/11/24.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var onboardingCellImage: UIImageView!
    
    @IBOutlet weak var onboardingCellTitleLabel: UILabel!
    
    @IBOutlet weak var onboardingCellDescriptionLabel: UILabel!
    
    
    func setup(_ cell: OnboardingCell){
        onboardingCellImage.image = cell.image
        onboardingCellTitleLabel.text = cell.title
        onboardingCellDescriptionLabel.text = cell.description
    }
    
}
