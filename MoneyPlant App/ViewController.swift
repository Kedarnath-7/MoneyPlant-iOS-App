//
//  ViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    
    @IBOutlet var sceneView: SCNView!
    
    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeVC), userInfo: nil, repeats: false)
        // setupScene()
        
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
    
//    func setupScene() {
//        sceneView = self.view as? SCNView
//        sceneView.allowsCameraControl = true
//        scene = SCNScene(named: "MainScene.scn")
//        sceneView.scene = scene
//        
//    }
    
    
}
