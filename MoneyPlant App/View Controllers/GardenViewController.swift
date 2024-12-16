//
//  GardenViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 20/11/24.
//

import UIKit
import SceneKit

class GardenViewController: UIViewController{
    
    @IBOutlet weak var sceneView: SCNView!
   // var sceneView: SCNView!
    var scene: SCNScene!
    
    lazy var bottomSheetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomVC") as? BottomSheetViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
       Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeVC), userInfo: nil, repeats: false)
        
        loadBottomSheetVC()
        
        var scene = SCNScene()
        
        let camerNode = SCNNode()
        camerNode.camera = SCNCamera()
        scene.rootNode.addChildNode(camerNode)
        
        //let sceneView = self.view as! SCNView
        scene = SCNScene(named: "Garden.scn")!
        sceneView.scene = scene
        // sceneView.scene = scene
        
        //sceneView.showsStatistics = true
        // sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = true
        
    }
    
    @objc func changeVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        vc.modalPresentationStyle = .automatic
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func unwindToGardenViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "continueUnwind",
              let _ = segue.source as? OnboardingViewController else{return}
        segue.source.modalPresentationStyle = .automatic
        segue.source.modalTransitionStyle = .coverVertical
    }
    
    func loadBottomSheetVC(){
        guard let sheetVC = bottomSheetVC else { return }
        
        if let sheet = sheetVC.sheetPresentationController{
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false // Inside Scrolling
            sheet.prefersGrabberVisible = true // Grabber button
            sheet.preferredCornerRadius = 30 // Radius
            sheet.largestUndimmedDetentIdentifier = .medium //Avoid dismiss
            self.present(sheetVC, animated: true)
        }
    }
    
    

}
    
