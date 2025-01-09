//
//  TransactionsTableViewCell.swift
//  SavingTransactions
//
//  Created by admin86 on 20/12/24.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var paidToLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var symbolLabel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update(with transaction: Transaction){
        paidToLabel.text = transaction.paidTo
        let category = transaction.category
        if !category.icon.isEmpty, let iconImage = UIImage(data: category.icon) {
            symbolLabel.image = iconImage
        } else {
            symbolLabel.image = UIImage(named: "default_icon")
        }
        if transaction.category.type == "Expense" {
            amountLabel.text = "- ₹\(transaction.amount)"
            amountLabel.textColor = .systemRed
        }else{
            amountLabel.text = "+ ₹\(transaction.amount)"
            amountLabel.textColor = .systemGreen
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateLabel.text = dateFormatter.string(from: transaction.date)
    }
}
