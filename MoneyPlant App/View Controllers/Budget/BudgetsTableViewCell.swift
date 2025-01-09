//
//  BudgetsTableViewCell.swift
//  SavingTransactions
//
//  Created by admin86 on 05/01/25.
//

import UIKit

class BudgetsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var dayLeftLbl: UILabel!
    @IBOutlet weak var amountLeftLbl: UILabel!
    @IBOutlet weak var amountSpentLbl: UILabel!
    @IBOutlet weak var amtSpentPercentLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with budget: CategoryBudget) {
        let monthYearFormatter = DateFormatter()
        monthYearFormatter.dateFormat = "MMM yyyy"
        let spentAmount = PersistenceController.shared.fetchTransactions().filter { transaction in
            guard transaction.category == budget.category else { return false }

            let transactionMonthYear = monthYearFormatter.string(from: transaction.date)
            return transactionMonthYear == budget.budget.monthYear
        }
        budget.spentAmount = spentAmount.reduce(0.0) { $0 + $1.amount }
        categoryNameLbl.text = budget.category.name
        categoryImage.image = UIImage(data: budget.category.icon)
        amountLeftLbl.text = String(budget.budgetedAmount - budget.spentAmount)
        amountSpentLbl.text = String(budget.spentAmount)
        amtSpentPercentLbl.text = String(format: "%.2f%% spent", budget.spentAmount.isZero ? 0 : (budget.spentAmount / budget.budgetedAmount) * 100)
        
        let totalBudget = budget.budget
        dayLeftLbl.text = "\(PersistenceController.shared.daysLeftInMonth(from: totalBudget.monthYear) ?? 0) days left"
        progressView.progress = Float(budget.spentAmount.isZero || budget.budgetedAmount.isZero ? 0 : budget.spentAmount / budget.budgetedAmount)
    }

}
