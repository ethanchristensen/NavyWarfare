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
    var worldNode = SCNNode()
    var cameraNode = SCNNode()
    var lastRotation = CGFloat()
    var rotateGesture = UIRotationGestureRecognizer()
    var lastSelectedShip = String()
    var attacking = Bool()
    var attackDamage = Int()
    var ShipsHealth = ["BattleshipSupporter": 100, "BattleshipCruiser": 100]
    var ShipsDamage = ["BattleshipSupporter": 40, "BattleshipCruiser": 40]
    var playerTurn = Bool()
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var controllerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSelectedShip = ""
        // create a new scene
        scene = SCNScene(named: "art.scnassets/Small Tropical Island.scn")!
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.camera!.orthographicScale = 4;
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
        lightNode.position = SCNVector3(x: 0, y: 20, z: 0)
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
        let scnView = self.gameView as! SCNView
        //self.view.sendSubviewToBack(self.controllerView)
        self.controllerView.hidden = true
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
        
        // add a pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        scnView.addGestureRecognizer(panGesture)
        
        
        let ship1 = scene.rootNode.childNodeWithName("BattleshipSupporter", recursively: true)!
        
        let ship2 = scene.rootNode.childNodeWithName("BattleshipCruiser", recursively: true)!
        worldNode.addChildNode(ship)
        worldNode.addChildNode(ship1)
        worldNode.addChildNode(ship2)
        
        scene.rootNode.addChildNode(worldNode)
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
    
    func handlePan(sender:UIPanGestureRecognizer){
        let translation = sender.translationInView(self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPointZero, inView: self.view)
       
        //worldNode.position = CGPoint(x:view.center.x + translation.x,
         //   y:view.center.y + translation.y)
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
        let scnView = self.gameView as! SCNView
        
        self.controllerView.hidden = false
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            //            if(result.name == "Battleship1"){
            //                let moveUp = SCNAction.moveByX(0.5, y: 0.0, z: 0.5, duration: 2.0)
            //                result.runAction(moveUp)
            //            }
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            let selectedNode = result.node!
            if(selectedNode.name!.containsString("Battleship")){
                lastSelectedShip = selectedNode.name!
                lastSelectedShip += "er"
                if(attacking){
                    doDamage()
                }
            }
            attacking = false
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
        }
        
    }
    
    func doDamage(){
        let ship = scene.rootNode.childNodeWithName(self.lastSelectedShip, recursively: true)
        if(ship != nil){
            ShipsHealth.updateValue(ShipsHealth[lastSelectedShip]! - attackDamage, forKey: lastSelectedShip)
            if(ShipsHealth[lastSelectedShip]! <= 0){
                destroyShip(ship!)
            }
        }
    }
    
    func destroyShip(ship: SCNNode){
        let moveUp = SCNAction.moveByX(0.0, y: -1.0, z: 0.0, duration: 2.0)
        ship.pivot = SCNMatrix4MakeRotation(Float(M_PI_4*2), 1, 0, 0)
        ship.runAction(moveUp)
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
    
    //Moves ship negative on the z
    @IBAction func forwardMovementAction(sender: AnyObject) {
        let ship = scene.rootNode.childNodeWithName(self.lastSelectedShip, recursively: true)
        
        if(ship != nil){
           // let rotate = SCNAction.rotateToAxisAngle(<#T##axisAngle: SCNVector4##SCNVector4#>, duration: <#T##NSTimeInterval#>)
            let moveUp = SCNAction.moveByX(0.0, y: 0.0, z: -0.5, duration: 1.0)
            //ship!.runAction(rotate)
        ship?.pivot = SCNMatrix4MakeRotation(Float(M_PI_2*2), 0, 1, 0)
            ship!.runAction(moveUp)
        }
    }
    
    @IBAction func leftMovementAction(sender: AnyObject) {
        let ship = scene.rootNode.childNodeWithName(self.lastSelectedShip, recursively: true)
        if(ship != nil){
            let moveUp = SCNAction.moveByX(-0.5, y: 0.0, z: -0.0, duration: 1.0)
            ship?.pivot = SCNMatrix4MakeRotation(Float(-M_PI_2), 0, 1, 0)
            ship!.runAction(moveUp)
        }
    }
    
    @IBAction func backMovementAction(sender: AnyObject) {
        let ship = scene.rootNode.childNodeWithName(self.lastSelectedShip, recursively: true)
        if(ship != nil){
            let moveUp = SCNAction.moveByX(0.0, y: 0.0, z: 0.5, duration: 1.0)
            ship?.pivot = SCNMatrix4MakeRotation(Float(M_PI_2*4), 0, 1, 0)
            ship!.runAction(moveUp)
        }
    }
    
    @IBAction func rightMovementAction(sender: AnyObject) {
        let ship = scene.rootNode.childNodeWithName(self.lastSelectedShip, recursively: true)
        if(ship != nil){
            let moveUp = SCNAction.moveByX(0.5, y: 0.0, z: 0.0, duration: 1.0)
            ship?.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 0, 1, 0)
            ship!.runAction(moveUp)
            
        }
    }
    
    
    @IBAction func attackButtonAction(sender: AnyObject) {
        attacking = true
        attackDamage = ShipsDamage[lastSelectedShip]!
    }
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        self.controllerView.hidden = true
        attacking = false
        lastSelectedShip = ""
    }
    
    func createGameObject(){
        var game = PFObject(className: "Game")
        game["player1"] = PFUser.currentUser()!.objectId
        game["turn"] = true
        game["ship"] = ""
        //game[]
    }
}