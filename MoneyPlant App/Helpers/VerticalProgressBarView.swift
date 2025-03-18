//
//  CircularProgressView.swift
//  SavingTransactions
//
//  Created by admin86 on 17/01/25.
//

import UIKit

class VerticalProgressBarView: UIView {

    private var progressLayer: CALayer!
    private var backgroundLayer: CALayer!

    var progressColor: UIColor = .blue {  // Default color
        didSet {
            progressLayer.backgroundColor = progressColor.cgColor  // Update color dynamically
        }
    }

    var progress: Float = 0 {
        didSet {
            setProgress(progress)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Create the background layer (Full Rectangle)
        backgroundLayer = CALayer()
        backgroundLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        backgroundLayer.frame = bounds
        backgroundLayer.cornerRadius = 5 // Optional rounded corners
        layer.addSublayer(backgroundLayer)

        // Create the progress layer (Initial height 0)
        progressLayer = CALayer()
        progressLayer.backgroundColor = progressColor.cgColor
        progressLayer.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0) // Starts empty
        progressLayer.cornerRadius = 5
        layer.addSublayer(progressLayer)
    }

    // Method to update progress
    private func setProgress(_ progress: Float) {
        let clampedProgress = max(0, min(progress, 1)) // Ensure value is between 0 and 1
        let newHeight = bounds.height * CGFloat(clampedProgress)

        UIView.animate(withDuration: 0.3) {
            self.progressLayer.frame = CGRect(x: 0, y: self.bounds.height - newHeight, width: self.bounds.width, height: newHeight)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup() // Re-setup layers in case of size changes
    }
}

