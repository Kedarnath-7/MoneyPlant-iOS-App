//
//  TransactionsTableViewCell.swift
//  MoneyPlant App
//
//  Created by admin86 on 05/11/24.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var recordImageView: UIImageView!
    
    @IBOutlet weak var recordNameLabel: UILabel!
     
    @IBOutlet weak var recordCategoryLabel: UILabel!
    
    @IBOutlet weak var recordAmountLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
