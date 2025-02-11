//
//  CurrencyFormatViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 22/12/24.
//

import UIKit

class CurrencyFormatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredCurrencies: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currency Format"
               tableView.dataSource = self
               tableView.delegate = self
        searchBar.delegate = self
        filteredCurrencies = currencies
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
                   cell.textLabel?.text = filteredCurrencies[indexPath.row]
                   cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                   cell.accessoryType = .none
                   return cell
        }
        
        // MARK: - UITableView Delegate Methods
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let selectedCurrency = filteredCurrencies[indexPath.row]
                   print("Selected Currency: \(selectedCurrency)")
                   
                   // Navigate back or save the selected currency
                   navigationController?.popViewController(animated: true)
        }
    
    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                filteredCurrencies = currencies
            } else {
                filteredCurrencies = currencies.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
            tableView.reloadData()
        }
    @objc func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            filteredCurrencies = currencies
            tableView.reloadData()
            searchBar.resignFirstResponder()
        }
    
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


