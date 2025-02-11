//
//  RegionViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 23/12/24.
//

import UIKit

class RegionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
       @IBOutlet weak var searchBar: UISearchBar!
    var groupedRegions: [String: [String]] = [:]
       var sectionTitles: [String] = []
       var filteredGroupedRegions: [String: [String]] = [:]
       var filteredSectionTitles: [String] = []
    var selectedRegion: String? {
           didSet {
               // Whenever selectedRegion changes, reload the table to update the checkmark
               tableView.reloadData()
           }
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Region"
               
               // Set up table view
               tableView.dataSource = self
               tableView.delegate = self
               
               // Set up search bar
               searchBar.delegate = self
               
               // Group and sort regions
               setupRegions()
               
               // Initially display all regions
               filteredGroupedRegions = groupedRegions
               filteredSectionTitles = sectionTitles
               
               // Set India as the default selected region
               if selectedRegion == nil {
                   selectedRegion = "India"  // Set India as the default
               }
               
        // Do any additional setup after loading the view.
    }
    
    func setupRegions() {
           groupedRegions = Dictionary(grouping: regions.sorted()) { String($0.prefix(1)) }
           sectionTitles = groupedRegions.keys.sorted()
       }
       
       // MARK: - UITableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
           return filteredSectionTitles.count
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           let sectionKey = filteredSectionTitles[section]
           return filteredGroupedRegions[sectionKey]?.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath)
           let sectionKey = filteredSectionTitles[indexPath.section]
           
           if let region = filteredGroupedRegions[sectionKey]?[indexPath.row] {
               cell.textLabel?.text = region
               // Set the checkmark based on the selected region
               cell.accessoryType = (region == selectedRegion) ? .checkmark : .none
           }
           
           cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
           return cell
       }
       
       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return filteredSectionTitles[section]
       }
       
       // MARK: - UITableView Delegate Methods
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           let sectionKey = filteredSectionTitles[indexPath.section]
           
           if let selectedRegion = filteredGroupedRegions[sectionKey]?[indexPath.row] {
               self.selectedRegion = selectedRegion  // Update the selected region
               print("Selected Region: \(selectedRegion)")
               
               // Reload the table to update checkmarks
               tableView.reloadData()
           }
       }
       
       // MARK: - UISearchBar Delegate Methods
       
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               filteredGroupedRegions = groupedRegions
               filteredSectionTitles = sectionTitles
           } else {
               filteredGroupedRegions = groupedRegions.mapValues {
                   $0.filter { $0.lowercased().contains(searchText.lowercased()) }
               }.filter { !$0.value.isEmpty }
               
               filteredSectionTitles = filteredGroupedRegions.keys.sorted()
           }
           tableView.reloadData()
       }
       
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.text = ""
           filteredGroupedRegions = groupedRegions
           filteredSectionTitles = sectionTitles
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


