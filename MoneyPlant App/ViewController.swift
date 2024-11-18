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
        setupScene()
        
    }
    
    func setupScene() {
        sceneView = self.view as? SCNView
        sceneView.allowsCameraControl = true
        scene = SCNScene(named: "MainScene.scn")
        sceneView.scene = scene
        
    }
    
    
}
