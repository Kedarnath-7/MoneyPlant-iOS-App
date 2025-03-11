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
    @IBOutlet weak var symbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update(with transaction: Transaction){
        paidToLabel.text = transaction.paidTo
        let category = transaction.category
        if !category.icon.isEmpty{
            symbolLabel.text = category.icon
        } else {
            symbolLabel.text = "❓"
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
