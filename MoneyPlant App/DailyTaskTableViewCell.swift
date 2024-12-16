//
//  DailyTaskTableViewCell.swift
//  MoneyPlant App
//
//  Created by admin86 on 16/12/24.
//

import UIKit

class DailyTaskTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var targetAmountLabel: UILabel!
    
    @IBOutlet weak var taskProgress: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
