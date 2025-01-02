//
//  TransactionsTableViewCell.swift
//  SavingTransactions
//
//  Created by admin86 on 05/11/24.
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

        // Configure the view for the selected state
    }

}
