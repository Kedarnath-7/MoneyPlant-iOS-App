//
//  CollectionViewCell1.swift
//  MoneyPlant App
//
//  Created by admin15 on 08/11/24.
//

import UIKit

class CollectionViewCell1: UICollectionViewCell {
    
    @IBOutlet weak var imageView1: UIImageView!

    @IBOutlet weak var nameLabel1: UILabel!
    
    func configure(with image: UIImage) {
            imageView1.image = image
        
        }
    override func awakeFromNib() {
            super.awakeFromNib()
            // Set border color, width, and corner radius for the imageView
            imageView1.layer.borderColor = UIColor.lightGray.cgColor
            imageView1.layer.borderWidth = 2.0
            imageView1.layer.cornerRadius = 8.0
            imageView1.clipsToBounds = true
        

        }
    }
    
    
    

