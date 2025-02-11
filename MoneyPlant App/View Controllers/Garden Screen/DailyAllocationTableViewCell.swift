//
//  DailyAllocationTableViewCell.swift
//  SavingTransactions
//
//  Created by admin86 on 16/01/25.
//

import UIKit

class DailyAllocationTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var allocatedAmountSlider: UISlider!
    @IBOutlet weak var spentAmountLabel: UILabel!
    @IBOutlet weak var remainingAmountLabel: UILabel!
    @IBOutlet weak var allocatedAmountLabel: UILabel!
    
    // MARK: - Variables
    var allocation: DailyAllocation? // Store the allocation being configured
    var onAllocationChanged: ((Double) -> Void)?
    
    // MARK: - Configuration
    func configure(with allocation: DailyAllocation, isEditable: Bool) {
        self.allocation = allocation // Assign the allocation to the property
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        dayLabel.text = formatter.string(from: allocation.date)
        
        // Set slider properties
        allocatedAmountSlider.maximumValue = Float(allocation.weeklyBudget.allocatedAmount)
        allocatedAmountSlider.minimumValue = 0
        allocatedAmountSlider.value = Float(allocation.allocatedAmount)
        allocatedAmountSlider.isEnabled = isEditable
        
        // Display calculated values
        allocatedAmountLabel.text = String(format: "₹ %.2f", allocation.allocatedAmount)
        spentAmountLabel.text = String(format: "₹ %.2f spent", allocation.spentAmount)
        let remaining = allocation.allocatedAmount - allocation.spentAmount
        remainingAmountLabel.text = String(format: "₹ %.2f left", max(remaining, 0.0))
        
        // Add target for slider changes (only if editable)
        if isEditable {
            allocatedAmountSlider.addTarget(self, action: #selector(didChangeAllocation), for: .valueChanged)
        } else {
            allocatedAmountSlider.removeTarget(self, action: #selector(didChangeAllocation), for: .valueChanged)
        }
    }

    @objc func didChangeAllocation(_ sender: UISlider) {
        guard let allocation = allocation else { return } // Ensure allocation is available
        let newAmount = Double(sender.value)
        allocatedAmountLabel.text = String(format: "₹ %.2f", newAmount)
        
        allocation.allocatedAmount = newAmount
        PersistenceController.shared.saveContext()
        
        onAllocationChanged?(newAmount)
    }
}
