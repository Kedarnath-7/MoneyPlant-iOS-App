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
    @IBOutlet weak var allocatedAmountTextField: UITextField!
    @IBOutlet weak var spentAmountLabel: UILabel!
    @IBOutlet weak var remainingAmountLabel: UILabel!
    @IBOutlet weak var lockButton: UIButton!
    
    // MARK: - Variables
    var allocation: DailyAllocation?
    var onAllocationChanged: ((Double) -> Void)?
    var onLockToggled: ((Bool) -> Void)?
    private var debounceTimer: Timer?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextField()
        setupLockButton()
    }
    
    // MARK: - Setup
    private func setupTextField() {
        allocatedAmountTextField.keyboardType = .decimalPad
        allocatedAmountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        allocatedAmountTextField.delegate = self
    }
    
    private func setupLockButton() {
        lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
        lockButton.setImage(UIImage(systemName: "lock.fill"), for: .selected)
        lockButton.addTarget(self, action: #selector(toggleLock(_:)), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    func configure(with allocation: DailyAllocation, isEditable: Bool, isInputEnabled: Bool) {
        self.allocation = allocation
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        dayLabel.text = formatter.string(from: allocation.date)
        
        allocatedAmountTextField.text = String(format: "%.2f", allocation.allocatedAmount)
        spentAmountLabel.text = String(format: "₹ %.2f spent", allocation.spentAmount)
        let remaining = allocation.allocatedAmount - allocation.spentAmount
        remainingAmountLabel.text = String(format: "₹ %.2f left", max(remaining, 0.0))
        
        allocatedAmountTextField.isEnabled = isEditable && isInputEnabled
        lockButton.isEnabled = isEditable
        lockButton.isSelected = allocation.isLocked
        
        // Update background color based on lock state
        contentView.backgroundColor = allocation.isLocked ? UIColor.lightGray.withAlphaComponent(0.3) : UIColor.white
    }
    
    // MARK: - Actions
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Debounce the input to prevent rapid updates
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self, let text = textField.text, let newAmount = Double(text), newAmount >= 0 else {
                textField.text = String(format: "%.2f", self?.allocation?.allocatedAmount ?? 0.0)
                return
            }
            self.allocation?.allocatedAmount = newAmount
            PersistenceController.shared.saveContext()
            self.onAllocationChanged?(newAmount)
        }
    }
    
    @objc func toggleLock(_ sender: UIButton) {
        sender.isSelected.toggle()
        allocation?.isLocked = sender.isSelected
        PersistenceController.shared.saveContext()
        onLockToggled?(sender.isSelected)
        
        // Update background color
        contentView.backgroundColor = sender.isSelected ? UIColor.lightGray.withAlphaComponent(0.3) : UIColor.white
    }
}

// MARK: - UITextFieldDelegate
extension DailyAllocationTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let newAmount = Double(text), newAmount >= 0 else {
            textField.text = String(format: "%.2f", allocation?.allocatedAmount ?? 0.0)
            return
        }
        textField.text = String(format: "%.2f", newAmount)
    }
}
