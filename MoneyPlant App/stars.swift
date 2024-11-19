//
//  stars.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/11/24.
//

import UIKit
import SceneKit

class stars: SCNParticleSystem {
    override init() {
        super.init()
        self.emitterShape = SCNSphere(radius: 5)
        self.emitterShape?.firstMaterial?.diffuse.contents = UIColor.white
        self.particleLifeSpan = 10
        self.birthRate = 300
        self.birthLocation = .surface
        self.warmupDuration = 5
        self.birthDirection = SCNParticleBirthDirection.random
        self.loops = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
