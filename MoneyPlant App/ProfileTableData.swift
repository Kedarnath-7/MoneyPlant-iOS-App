//
//  ProfileTableViewCell.swift
//  MoneyPlant App
//
//  Created by Rohan on 12/11/24.
//

import UIKit

struct ProfileTable{
    var symbol: UIImage
    var title: String
}

var profileTable: [ProfileTable] = [
    ProfileTable(symbol: UIImage(systemName: "wallet.bifold")!, title: "Account"),
    ProfileTable(symbol: UIImage(systemName: "gearshape.2")!, title: "Settings"),
    ProfileTable(symbol: UIImage(systemName: "questionmark")!, title: "Help & Support"),
    ProfileTable(symbol: UIImage(systemName: "iphone.and.arrow.right.outward")!, title: "Logout")
]
