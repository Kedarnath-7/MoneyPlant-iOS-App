//
//  HelpViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 19/12/24.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var faqContainerView: UIView!
    @IBOutlet weak var contactContainerView: UIView!

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            faqContainerView.isHidden = false
            contactContainerView.isHidden = true
        } else {
            faqContainerView.isHidden = true
            contactContainerView.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
              title = "Help & Support"
        segmentedControl.selectedSegmentIndex = 0
        faqContainerView.isHidden = false
               contactContainerView.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
