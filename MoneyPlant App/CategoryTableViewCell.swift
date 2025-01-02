//
//  CategoryTableViewCell.swift
//  MoneyPlant App
//
//  Created by admin15 on 18/11/24.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryAmountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var categoryImageView: UIImageView!

       override func awakeFromNib() {
           super.awakeFromNib()
               
           
       }

       // Configure cell with category data
    func configure(with category: (name: String, value: Double, color: UIColor, symbol: UIImage), totalValue: Double) {
           categoryNameLabel.text = category.name
           categoryAmountLabel.text = "₹\(Int(category.value))"
           categoryNameLabel.textColor = .black
           categoryAmountLabel.textColor = .black
           
           // Set the progress bar to match category color
           let progress = Float(category.value / totalValue)
           progressView.setProgress(progress, animated: true)
           progressView.progressTintColor = category.color
           
           // Set the category icon
           categoryImageView.image = category.symbol
        categoryImageView.tintColor = .black  // Set tint color for the symbol to match category
       }
   }
