//
//  AddNewRecordTableViewCell.swift
//  MoneyPlant App
//
//  Created by admin86 on 14/11/24.
//

import UIKit

class AddNewRecTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
