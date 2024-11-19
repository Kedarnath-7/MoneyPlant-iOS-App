//
//  GardenViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 20/11/24.
//

import UIKit
import SceneKit

class GardenViewController: UIViewController {
    
    var sceneView: SCNView!
    var scene: SCNScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        var scene = SCNScene()
        
        let camerNode = SCNNode()
        camerNode.camera = SCNCamera()
        scene.rootNode.addChildNode(camerNode)
        
        let sceneView = self.view as! SCNView
        scene = SCNScene(named: "/MainScene.scn")!
        sceneView.scene = scene
        // sceneView.scene = scene
        
        sceneView.showsStatistics = true
        sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = true
        
        
        // setupScene()
        
    }
    func setupScene(){
        sceneView = self.view as? SCNView
        sceneView.allowsCameraControl = true
        scene = SCNScene(named: "MainScene.scn")
        sceneView.scene = scene
    }
    
}
    
