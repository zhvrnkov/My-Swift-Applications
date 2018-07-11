//
//  ViewController.swift
//  AR Ruler
//
//  Created by Vladislav Zhavoronkov on 03/06/2018.
//  Copyright © 2018 Vladislav Zhavoronkov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    func addDot(at hitResult: ARHitTestResult) {
        let sphere = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        sphere.materials = [material]
        let node = SCNNode(geometry: sphere)
        
        node.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                   y: hitResult.worldTransform.columns.3.y,
                                   z: hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(node)
        
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let coord = ((end.position.x - start.position.x), (end.position.y - start.position.y), (end.position.z - start.position.z))
        
        let module = powf(powf(coord.0, 2) + powf(coord.1, 2) + powf(coord.2, 2), 0.5)
        
        updateText(text: "\(abs(module))", position: end.position)
    }
    
    func updateText(text: String, position: SCNVector3) {
        textNode.removeFromParentNode()
        
        let textGeom = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeom.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeom)
        textNode.position = SCNVector3(x: position.x,
                                       y: position.y - 0.01,
                                       z: position.z)
        textNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) { //location in 2d (on screen)
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)//transform 2d location (on screen) to 3d location (in real world)
            
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}
