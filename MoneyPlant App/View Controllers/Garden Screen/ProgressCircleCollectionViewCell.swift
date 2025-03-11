//
//  ProgressCircleCollectionViewCell.swift
//  SavingTransactions
//
//  Created by admin86 on 16/01/25.
//

import UIKit

class ProgressCircleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dailyProgress: UIImageView!
    
    func configure(dailyGrowth: Double, maxGrowth: Double, day: String, isFutureDate: Bool) {
        _ = dailyGrowth / max(maxGrowth, 1.0)
        
        //progressView.layer.cornerRadius = progressView.frame.height / 2
        dayLabel.text = day
        
        if isFutureDate {
            //progressView.progressColor = UIColor.lightGray
            dailyProgress.image = UIImage(systemName: "camera.macro.slash.circle")
            dailyProgress.tintColor = UIColor.systemGray2
            
        } else{
            //progressView.progress = 1.0
            if dailyGrowth == 0.0 {
                //progressView.progressColor = UIColor.systemRed
                dailyProgress.image = UIImage(systemName: "camera.macro.slash.circle")
                dailyProgress.tintColor = UIColor.systemRed
            } else {
                //progressView.progressColor = UIColor.systemGreen
                dailyProgress.image = UIImage(systemName: "camera.macro.circle.fill")
                dailyProgress.tintColor = UIColor.systemGreen
            }
        }
    }
}

