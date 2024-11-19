//
//  GraphView.swift
//  MoneyPlant App
//
//  Created by admin15 on 19/11/24.
//
import UIKit



class LineGraphView: UIView {
    // Data points for the graph
    var dataPoints: [CGFloat] = [2000, 5000, 3000, 7000, 10000, 8000, 4000]
    var labels: [String] = ["23 Mo", "24 Tu", "25 We", "26 Th", "27 Fr", "28 Sa", "29 Su"]
    
    // Colors for the graph
    let lineColor: UIColor = .systemPurple
    let gradientColor: UIColor = .systemPurple.withAlphaComponent(0.3)
    let markerColor: UIColor = .systemPurple
    let markerSize: CGFloat = 8.0
    
   
    override func draw(_ rect: CGRect) {
        guard dataPoints.count > 1 else { return }
        
        let context = UIGraphicsGetCurrentContext()
        let maxValue = dataPoints.max() ?? 0
        let minValue = dataPoints.min() ?? 0
        let range = maxValue - minValue
        
        let graphWidth = rect.width
        let graphHeight = rect.height - 40 // Leave space for x-axis labels
        let spacing = graphWidth / CGFloat(dataPoints.count - 1)
        
        // Transform data points into coordinates
        let points = dataPoints.enumerated().map { (index, value) -> CGPoint in
            let normalizedValue = range == 0 ? 0.5 : (value - minValue) / range
            let x = CGFloat(index) * spacing
            let y = graphHeight - normalizedValue * graphHeight
            return CGPoint(x: x, y: y)
        }
        
        // Debug calculated points
        for point in points {
            print("Calculated Point: \(point)")
        }
        
        // Draw gradient fill
        let gradientPath = UIBezierPath()
        gradientPath.move(to: CGPoint(x: 0, y: graphHeight))
        for point in points {
            gradientPath.addLine(to: point)
        }
        gradientPath.addLine(to: CGPoint(x: points.last!.x, y: graphHeight))
        gradientPath.close()
        
        context?.saveGState()
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: [lineColor.cgColor, UIColor.clear.cgColor] as CFArray,
                                  locations: [0.0, 1.0])!
        context?.addPath(gradientPath.cgPath)
        context?.clip()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint(x: rect.midX, y: 0),
                                    end: CGPoint(x: rect.midX, y: graphHeight),
                                    options: [])
        context?.restoreGState()
        
        // Draw the line
        let linePath = UIBezierPath()
        linePath.move(to: points[0])
        for i in 1..<points.count {
            linePath.addLine(to: points[i])
        }
        lineColor.setStroke()
        linePath.lineWidth = 2.0
        linePath.stroke()
        
        // Draw markers
        for point in points {
            let markerPath = UIBezierPath(ovalIn: CGRect(x: point.x - markerSize / 2,
                                                         y: point.y - markerSize / 2,
                                                         width: markerSize,
                                                         height: markerSize))
            markerColor.setFill()
            markerPath.fill()
        }
        
        // Draw x-axis labels
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.gray,
            .paragraphStyle: paragraphStyle
        ]
        
        for (index, label) in labels.enumerated() {
            let x = CGFloat(index) * spacing
            let labelRect = CGRect(x: x - 20, y: graphHeight + 5, width: 40, height: 20)
            label.draw(in: labelRect, withAttributes: attributes)
        }
    }
}
