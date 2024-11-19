//
//  AddNewCategoryTableViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 14/11/24.
//

import UIKit

class AddNewCategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
extension AddNewCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "categoryNameCell", for: indexPath) as? AddNewCategoryTableViewCell else { return UITableViewCell() }
        cell1.addNewCategoryName.placeholder = "Category Name"
//        cell1.addNewCategoryType.placeholder = "Category Type"
//        cell1.addNewCategoryRegular.placeholder = "Regular Record"
//        cell1.addNewCategoryTags.text = "Tags"
        
        return cell1
    }
    
}
