//
//  StoreViewController.swift
//  SavingTransactions
//
//  Created by admin86 on 16/03/25.
//

import UIKit
import CoreData

class StoreViewController: UIViewController {
    
    @IBOutlet weak var plantCoinsButton: UIButton!
    @IBOutlet weak var plantsCollectionView: UICollectionView!
    @IBOutlet weak var environmentsCollectionView: UICollectionView!
    
    var plantSpecies: [PlantSpecie] = []
    var environments: [Environment] = []
    var user: UserAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantsCollectionView.delegate = self
        plantsCollectionView.dataSource = self
        environmentsCollectionView.delegate = self
        environmentsCollectionView.dataSource = self
        
        fetchUser()
        fetchStoreData()
    }

    func fetchUser() {
        let fetchRequest: NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
        do {
            user = try PersistenceController.shared.context.fetch(fetchRequest).first
            updatePlantCoinsButton()
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    func fetchStoreData() {
        let specieFetch: NSFetchRequest<PlantSpecie> = PlantSpecie.fetchRequest()
        let environmentFetch: NSFetchRequest<Environment> = Environment.fetchRequest()

        do {
            plantSpecies = try PersistenceController.shared.context.fetch(specieFetch)
            environments = try PersistenceController.shared.context.fetch(environmentFetch)
            plantsCollectionView.reloadData()
            environmentsCollectionView.reloadData()
        } catch {
            print("Error fetching store data: \(error)")
        }
    }

    func updatePlantCoinsButton() {
        guard let user = user else { return }
        plantCoinsButton.setTitle("⭐️ \(user.plantCoins)", for: .normal)
    }

    func unlockItem(_ item: NSManagedObject) {
        guard let user = user else { return }
        
        if let plant = item as? PlantSpecie, !plant.isUnlocked, user.plantCoins >= plant.requiredCoins {
            user.plantCoins -= plant.requiredCoins
            plant.isUnlocked = true
        } else if let env = item as? Environment, !env.isUnlocked, user.plantCoins >= env.requiredCoins {
            user.plantCoins -= env.requiredCoins
            env.isUnlocked = true
        } else {
            showAlert(title: "Not Enough Coins", message: "You need more coins to unlock this item.")
            return
        }

        do {
            try PersistenceController.shared.context.save()
            updatePlantCoinsButton()
            plantsCollectionView.reloadData()
            environmentsCollectionView.reloadData()
        } catch {
            print("Error unlocking item: \(error)")
        }
    }

    func applyItemToGarden(_ item: NSManagedObject) {
        if let currentMonthPlant = fetchCurrentMonthPlant() {
            if let plantSpecie = item as? PlantSpecie {
                currentMonthPlant.plantSpecie = plantSpecie
            } else if let environment = item as? Environment {
                currentMonthPlant.environment = environment
            }
            PersistenceController.shared.saveContext()
            
            NotificationCenter.default.post(name: NSNotification.Name("UpdateGardenScene"), object: nil)
            
            let alert = UIAlertController(title: "Updated!", message: "Your selection has been updated in the Garden!", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Go to Garden", style: .default, handler: { _ in
                self.navigateToGardenScreen()
            }))

            present(alert, animated: true, completion: nil)
        }
    }
    
    func navigateToGardenScreen() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        } else {
            print("❌ Garden screen navigation failed")
        }
    }
    
    func fetchCurrentMonthPlant() -> Plant? {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.fetchLimit = 1

        do {
            return try PersistenceController.shared.context.fetch(fetchRequest).first
        } catch {
            print("Error fetching current plant: \(error)")
            return nil
        }
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in completion?() }))
        present(alert, animated: true)
    }
}

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == plantsCollectionView) ? plantSpecies.count : environments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCell", for: indexPath) as? StoreCollectionViewCell else {
            return UICollectionViewCell()
        }

        
        if collectionView == plantsCollectionView {
            let plant = plantSpecies[indexPath.item]
            let image = UIImage(named: plant.image) ?? UIImage(systemName: "leaf")!
            let buttonTitle = plant.isUnlocked ? "Use" : "\(plant.requiredCoins) ⭐️"
            
            cell.configure(image: image, name: plant.name, buttonTitle: buttonTitle)
        } else {
            let environment = environments[indexPath.item]
            let image = UIImage(named: environment.image) ?? UIImage(systemName: "leaf")!
            let buttonTitle = environment.isUnlocked ? "Use" : "\(environment.requiredCoins) ⭐️"
            
            cell.configure(image: image, name: environment.name, buttonTitle: buttonTitle)
        }

        cell.requiredCoinsButton.tag = indexPath.item
        cell.requiredCoinsButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        return cell
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let isPlant = sender.superview?.superview?.superview == plantsCollectionView

        if isPlant {
            let plant = plantSpecies[sender.tag] 
            handleItemSelection(plant)
        } else {
            let environment = environments[sender.tag] 
            handleItemSelection(environment)
        }
    }

    func handleItemSelection(_ item: NSManagedObject) {
        if let plant = item as? PlantSpecie {
            if plant.isUnlocked {
                applyItemToGarden(plant)
            } else {
                showAlert(title: "Unlock Item?", message: "Do you want to unlock \(plant.name) for \(plant.requiredCoins) ⭐️?", completion: {
                    self.unlockItem(plant)
                })
            }
        } else if let environment = item as? Environment {
            if environment.isUnlocked {
                applyItemToGarden(environment)
            } else {
                showAlert(title: "Unlock Item?", message: "Do you want to unlock \(environment.name) for \(environment.requiredCoins) ⭐️?", completion: {
                    self.unlockItem(environment)
                })
            }
        }
    }

}

