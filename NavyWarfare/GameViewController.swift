//
//  GameViewController.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 11/4/15.
//  Copyright (c) 2015 Ethan Christensen. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, UIScrollViewDelegate {
    
    var scene = SCNScene()
    var cameraNode = SCNNode()
    var lastRotation = CGFloat()
    var rotateGesture = UIRotationGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/Small Tropical Island.scn")!
        // create and add a camera to the scene
        cameraNode = scene.rootNode.childNodeWithName("camera", recursively: true)!
        cameraNode.camera = SCNCamera()
        //cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.camera!.zNear = 0
        cameraNode.camera!.zFar = 100
        scene.rootNode.addChildNode(cameraNode)
        //self.controllerView.hidden = true
        // place the camera
        
        //let constraint = SCNLookAtConstraint(target: <#T##SCNNode#>)
        //constraint.gimbalLockEnabled = true
        //cameraNode.constraints =
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 30, z: 0)
        //scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.blueColor()
        //scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNodeWithName("Island", recursively: true)!
        
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 0)
        let constraint = SCNLookAtConstraint(target: ship);
        constraint.gimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        /*let cameraOrbit = SCNNode()
        // rotate it (I've left out some animation code here to show just the rotation)
        cameraOrbit.eulerAngles.x -= Float(M_PI_4)
        cameraOrbit.eulerAngles.y -= Float(M_PI_4*3)
        cameraOrbit.name = "CameraOrbit"
        cameraOrbit.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cameraOrbit)*/
        
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        //scnView.allowsCameraControl = true
        
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.whiteColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        scnView.addGestureRecognizer(tapGesture)
        
        // add a swipe gesture recognizer
        rotateGesture = UIRotationGestureRecognizer(target: self, action: "handleRotate:")
        scnView.addGestureRecognizer(rotateGesture)
        
        
        //scrollView.contentSize = cameraNode.camera!.accessibilityFrame.size
       // scrollView.addSubview(cameraNode.camera!.)

        //scnView.addSubview(scrollView)
        //TODO:
        //self.view.bringSubviewToFront
        //Possibly use UIKIT to create menu, and hide behind gameview until ready
    }
    
    func handleSwipe(gestureRecognize: UISwipeGestureRecognizer){
        if(gestureRecognize.direction == UISwipeGestureRecognizerDirection.Left){
            cameraNode.position.x += 0.02
        }
    }
    
    func rotatedView(sender:UIRotationGestureRecognizer){
        var lastRotation = CGFloat()
        
        if(sender.state == UIGestureRecognizerState.Ended){
            lastRotation = 0.0;
        }
        let rotation = 0.0 - (lastRotation - sender.rotation)
        //var point = rotateGesture.locationInView()
        //var currentTrans = sender.view.transform
        //var newTrans = CGAffineTransformRotate(currentTrans, rotation)
        //sender.view.transform = newTrans
        //lastRotation = sender.rotation
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let cameraOrbit = scene.rootNode.childNodeWithName("CameraOrbit", recursively: true)
        let scrollWidthRatio = Float(scrollView.contentOffset.x / scrollView.frame.size.width)
        let scrollHeightRatio = Float(scrollView.contentOffset.y / scrollView.frame.size.height)
        cameraOrbit!.eulerAngles.y = Float(-2 * M_PI) * scrollWidthRatio
        cameraOrbit!.eulerAngles.x = Float(-M_PI) * scrollHeightRatio
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            if(result.name == "Battleship1"){
                let moveUp = SCNAction.moveByX(0.5, y: 0.0, z: 0.5, duration: 2.0)
                result.runAction(moveUp)
            }
            // get its material
            /*let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }*/
    
        }
    
    }
    
    func degToRad(deg: Float)->Float {
        return deg / 180 * Float(M_PI)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}