//
//  ViewController2.swift
//  MoneyPlant App
//
//  Created by admin15 on 08/11/24.
//

import UIKit


let plantImages: [UIImage] = [
    UIImage(named: "plant1")!,
    UIImage(named: "plant2")!,
    UIImage(named: "plant3")!,
    UIImage(named: "plant4")!
]
let plantNames: [String] = ["Money plant", "Rose plant", "Bonsai", "velvet"]

let environmentImages: [UIImage] = [
    UIImage(named: "env1")!,
    UIImage(named: "env2")!,
    UIImage(named: "env3")!,
    UIImage(named: "env4")!
]
let environmentNames: [String] = ["Sapphire", "Twilight", "Green Timber", "Nightfall"]


class ViewController2: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return plantImages.count
        } else if collectionView == collectionView2 {
            return environmentImages.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! CollectionViewCell1
            cell.imageView1.image = plantImages[indexPath.item]
            cell.nameLabel1.text = plantNames[indexPath.item]// Set the plant image
            return cell
        } else if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewCell2
            cell.imageView2.image = environmentImages[indexPath.item]
            cell.nameLabel2.text = environmentNames[indexPath.item]// Set the environment image
            return cell
        }
        return UICollectionViewCell()
    }
    

    
    
    @IBOutlet weak var collectionView1: UICollectionView!
    
    @IBOutlet weak var collectionView2: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

           collectionView1.delegate = self
           collectionView1.dataSource = self
           
           collectionView2.delegate = self
           collectionView2.dataSource = self
        
        
        let layout1 = UICollectionViewFlowLayout()
            layout1.scrollDirection = .horizontal
            layout1.itemSize = CGSize(width: 200, height:200) // Adjust size as needed
            collectionView1.collectionViewLayout = layout1
            
            // Configure layout for collectionView2
            let layout2 = UICollectionViewFlowLayout()
            layout2.scrollDirection = .horizontal
            layout2.itemSize = CGSize(width: 200, height: 200) // Adjust size as needed
            collectionView2.collectionViewLayout = layout2
        
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
