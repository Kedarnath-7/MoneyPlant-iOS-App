//
//  InsightsTableViewCell.swift
//  SavingTransactions
//
//  Created by admin86 on 15/03/25.
//

import UIKit

class InsightsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryIconLbl: UILabel!
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var categoryAmountLbl: UILabel!
    @IBOutlet weak var progressViewOutlet: UIProgressView!
    
    func configure(icon: String, name: String, amount: Double, progress: Double) {
        categoryIconLbl.text = icon
        categoryNameLbl.text = name
        categoryAmountLbl.text = String(format: "₹%.2f", amount)
        progressViewOutlet.progress = Float(progress)
    }
    
}
