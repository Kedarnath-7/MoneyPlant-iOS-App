//
//  AddNewCategoryTableViewCell.swift
//  MoneyPlant App
//
//  Created by admin86 on 14/11/24.
//

import UIKit

class AddNewCategoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var addNewCategoryName: UITextField!
    
    @IBOutlet weak var addNewCategoryType: UITextField!
    
    @IBOutlet weak var addNewCategoryRegular: UITextField!
    
    @IBOutlet weak var addNewCategoryTags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
