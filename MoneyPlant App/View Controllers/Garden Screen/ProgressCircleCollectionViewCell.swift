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
    
    func configure(dailyGrowth: Double, maxGrowth: Double, day: String, isFutureDate: Bool) {
        let progress = dailyGrowth / max(maxGrowth, 1.0)
        print("Progress: \(Float(progress))")
        progressView.progress = Float(progress)
        progressView.layer.cornerRadius = progressView.frame.height / 2
        dayLabel.text = day
        print("Day: \(day)")
        
        if isFutureDate {
            progressView.progressColor = UIColor.systemBlue
            print("Future Date")
        } else{
            if dailyGrowth != 0.0 {
                progressView.progressColor = UIColor.systemGreen
                print("Positive Growth")
            }else{
                progressView.progressColor = UIColor.systemGreen
                print("No Growth")
            }
        }
    }
}

