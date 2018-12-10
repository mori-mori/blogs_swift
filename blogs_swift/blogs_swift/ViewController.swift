//
//  ViewController.swift
//  blogs_swift
//
//  Created by Tatsunori on 2018/12/09.
//  Copyright © 2018 Tatsunori. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        // タップした画面のSCNViewからCGPointに変換
        let tapPoint = sender.location(in: sceneView)
        // 現実世界のオブジェクト、ARアンカーを配列で取得
        let results = sceneView.hitTest(tapPoint, types: .featurePoint)
        // 配列の最初の要素を取得
        if let hitPoint = results.first {
            let point = SCNVector3.init(hitPoint.worldTransform.columns.3.x,
                                        hitPoint.worldTransform.columns.3.y,
                                        hitPoint.worldTransform.columns.3.z)
            print("X座標；\(point.x) Y座標：\(point.y) Z座標：\(point.z)")
            
            let node = SCNNode()
            // Boxオブジェクトを作成
            node.geometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
            // SCNNodeのphysicsBodyに重力を設定
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: node.geometry!, options: nil))
            // Boxの色を青色に設定
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            node.geometry?.materials = [material]
            // 表示場所をタップで取得した現実世界の座標を設定
            node.position = point
            // SCNSceneにNodeを追加して画面に表示
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                node.addChildNode(PlaneNode(anchor: planeAnchor))
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes[0] as? PlaneNode {
                planeNode.update(anchor: planeAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
}
