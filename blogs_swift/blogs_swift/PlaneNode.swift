//
//  PlaneNode.swift
//  blogs_swift
//
//  Created by Tatsunori on 2018/12/10.
//  Copyright © 2018 Tatsunori. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class PlaneNode: SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 0.5)
        geometry?.materials = [planeMaterial]
        // 認識したanchorの位置にPlaneを設定する
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        // 180度回転させて横向きにする
        transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
    }
    
    func update(anchor: ARPlaneAnchor) {
        // 矯正ダウンキャストで親クラスのSCNPlaneにへ変換してサイズを指定
        (geometry as! SCNPlane).width = CGFloat(anchor.extent.x)
        (geometry as! SCNPlane).height = CGFloat(anchor.extent.z)
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
    }
}
