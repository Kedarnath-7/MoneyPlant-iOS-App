//
//  OnboardingViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 19/11/24.
//

import UIKit

class OnboardingViewController: UIViewController {

    
    var cells: [OnboardingCell] = [
        OnboardingCell(title: "Plant Metaphor For Savings", description: "Watch your interactive plant flourish as you manage your finances effectively.", image: UIImage(systemName: "tree.fill")!),
        OnboardingCell(title: "Income & Expense Tracking", description: "Add income or expense records in just a few taps with an intuitive interface.", image: UIImage(systemName: "list.bullet.rectangle.portrait.fill")!),
        OnboardingCell(title: "Personalised Budgets", description: "Set and track daily, weekly, & monthly budgets to stay on track.", image: UIImage(systemName: "chart.pie.fill")!),
        OnboardingCell(title: "Gamification & Rewards", description: "Earn rewards and unlock special features to keep your savings journey exciting.", image: UIImage(systemName: "storefront.fill")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func continueButtonClicked(_ sender: UIButton) {
    }
}
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        
        cell.setup(cells[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 361, height: 120)
    }
    
}
