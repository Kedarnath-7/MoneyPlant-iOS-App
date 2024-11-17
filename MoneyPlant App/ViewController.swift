//
//  ViewController.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        scene.rootNode.addChildNode(cameraNode)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        
        scene.rootNode.addChildNode(lightNode)
        
       let stars = SCNParticleSystem(named: "stars.swift", inDirectory: nil)!
        scene.rootNode.addParticleSystem(stars)
        
        let earthNode = EarthNode()
        scene.rootNode.addChildNode(earthNode)
        
        let sceneView = self.view as? SCNView
        sceneView?.scene = scene
        
        sceneView?.showsStatistics = true
        sceneView?.backgroundColor = .black
        sceneView?.allowsCameraControl = true
        
    }


}
