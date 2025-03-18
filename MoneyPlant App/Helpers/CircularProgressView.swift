//
//  CircularProgressView.swift
//  SavingTransactions
//
//  Created by admin86 on 18/03/25.
//


import UIKit

class CircularProgressView: UIView {

    private var progressLayer: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!

    var progressColor: UIColor = .blue {  // Default color
        didSet {
            progressLayer.strokeColor = progressColor.cgColor  // Update the stroke color dynamically
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
        // Create the progress circle
        progressLayer = CAShapeLayer()
        progressLayer.strokeColor = progressColor.cgColor // Use the dynamic color
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 5
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0  // Start with no progress
        layer.addSublayer(progressLayer)

        // Create the background circle
        backgroundLayer = CAShapeLayer()
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 0.2
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)

        let radius = min(bounds.width, bounds.height) / 2 - 5  // Padding for the line width
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi + startAngle

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }

    // Method to update progress
    private func setProgress(_ progress: Float) {
        progressLayer.strokeEnd = CGFloat(progress)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup() // Re-setup the layers in case the bounds change
    }
}