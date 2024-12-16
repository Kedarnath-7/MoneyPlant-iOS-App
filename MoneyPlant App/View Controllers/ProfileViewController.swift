//
//  ProfileViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 16/12/24.
//

import UIKit

class ProfileViewController: UIViewController {

    struct Profile{
        var name: String
        var symbol: UIImage
    }
    
    var profileCells = [Profile(name: "Account", symbol: UIImage(systemName: "wallet.bifold")!), Profile(name: "Settings", symbol: UIImage(systemName: "gearshape")!), Profile(name: "Help & Support", symbol: UIImage(systemName: "questionmark")!), Profile(name: "Log Out", symbol: UIImage(systemName: "rectangle.portrait.and.arrow.right")!)]
    
    
    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        profileCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.cellImage.image = profileCells[indexPath.section].symbol
        cell.cellTitle.text = profileCells[indexPath.section].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    
}
