//
//  FAQViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 20/12/24.
//

import UIKit

class FAQViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var faqTableView: UITableView!
    
    
    let categories = ["General", "Expense", "Savings", "Tasks", "Security", "Account", "Issues"]
    var selectedCategoryIndex: Int = 0 // Track the selected category
    var filteredFaqCategories: [FAQCategory] = [] // To store filtered categories
    
    
    override func viewDidLoad() {
           super.viewDidLoad()

           // Filter FAQs based on selected category
           filterFAQData(for: selectedCategoryIndex)

           // Set up table view and collection view delegates and data sources
           categoryCollectionView.delegate = self
           categoryCollectionView.dataSource = self
           faqTableView.delegate = self
           faqTableView.dataSource = self

           faqTableView.rowHeight = UITableView.automaticDimension
           faqTableView.estimatedRowHeight = 100 // Estimate row height for better performance
       }

       // MARK: - UICollectionView DataSource
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return categories.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
               return UICollectionViewCell()
           }

           cell.categoryButton.setTitle(categories[indexPath.row], for: .normal)
           let isSelected = indexPath.row == selectedCategoryIndex
           cell.configure(isSelected: isSelected)

           // Set the button action
           cell.buttonAction = { [weak self] in
               guard let self = self else { return }
               self.selectedCategoryIndex = indexPath.row
               self.filterFAQData(for: self.selectedCategoryIndex)
               self.categoryCollectionView.reloadData()
               self.faqTableView.reloadData() // Reload table view after category change
           }

           return cell
       }

       // MARK: - UITableView DataSource
       func numberOfSections(in tableView: UITableView) -> Int {
           return filteredFaqCategories.count
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return filteredFaqCategories[section].questions.count
       }

       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return filteredFaqCategories[section].title
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath)
           let faq = filteredFaqCategories[indexPath.section].questions[indexPath.row]

           cell.textLabel?.text = faq.question
           cell.detailTextLabel?.text = faq.isExpanded ? faq.answer : nil
           print("FAQ Answer Expanded: \(faq.isExpanded ? faq.answer : "No Answer")")
           return cell
       }

       // MARK: - UITableView Delegate
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
           // Toggle the expansion state
           var selectedFAQ = filteredFaqCategories[indexPath.section].questions[indexPath.row]
               selectedFAQ.isExpanded.toggle()
           
           filteredFaqCategories[indexPath.section].questions[indexPath.row].toggleExpanded()
         
           // Reload the selected row to update the visibility of the answer
           tableView.reloadRows(at: [indexPath], with: .automatic)
       }

       // MARK: - Helper Methods
       // Filter FAQ data based on the selected category index
       func filterFAQData(for categoryIndex: Int) {
           let selectedCategory = categories[categoryIndex]
           filteredFaqCategories = faqCategories.filter { $0.title == selectedCategory }
       }
   }
