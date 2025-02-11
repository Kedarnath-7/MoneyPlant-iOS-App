//
//  CategoryCollectionViewCell.swift
//  MoneyPlant App
//
//  Created by admin15 on 20/12/24.
//

import UIKit



class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    
    var buttonAction: (() -> Void)?

       override func awakeFromNib() {
           super.awakeFromNib()
           
           // Customize button appearance
           setupCategoryButton()
           
           // Add button action
           categoryButton.addTarget(self, action: #selector(handleCategoryButtonTap), for: .touchUpInside)
       }

       private func setupCategoryButton() {
//           categoryButton.backgroundColor = .systemGray5
//           categoryButton.backgroundColor = isSelected ? UIColor.black : UIColor.systemGray5
//           categoryButton.setTitleColor(.white, for: .normal)
           categoryButton.layer.cornerRadius = 15
           categoryButton.layer.masksToBounds = true

           // Set text alignment and scaling
           categoryButton.titleLabel?.textAlignment = .center
           categoryButton.titleLabel?.adjustsFontSizeToFitWidth = true
           categoryButton.titleLabel?.minimumScaleFactor = 0.5
           
        

           // Disable highlight effect
           categoryButton.adjustsImageWhenHighlighted = false
       }

       @objc private func handleCategoryButtonTap() {
           buttonAction?() // Call the closure
       }

       func configure(isSelected: Bool) {
           // Update button appearance based on selection state
           categoryButton.backgroundColor = isSelected ? .black : .systemGray5
           categoryButton.setTitleColor(isSelected ? .white : .black, for: .normal)
       }
   }
