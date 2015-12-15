//
//  GameViewController.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 11/4/15.
//  Copyright (c) 2015 Ethan Christensen. All rights reserved.
//
//  iOS Semester Project 2015.  ETHAN CHRISTENSEN & GERAD WEGENER


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
    var playersAttackingShip = String()
    var notCheckedTurn: Bool = true
    var moved: Bool = false
    var attackDamage = Int()
    var ShipsHealth = ["Battleship1SupporterGame": 100, "Battleship1CruiserGame": 100, "Battleship2SupporterGame": 100, "Battleship2CruiserGame": 100, "Battleship1CarrierGame": 100, "Battleship2CarrierGame": 100]
    var ShipsDamage = ["Battleship1SupporterGame": 100, "Battleship1CruiserGame": 100, "Battleship2SupporterGame": 100, "Battleship2CruiserGame": 100, "Battleship1CarrierGame": 100, "Battleship2CarrierGame": 100]
    
    var player1: Bool = false
    var yourTurn: Bool = false
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var controllerView: UIView!
    
    var player2Id: PFUser? {
        didSet {
            //update the view.
            self.createGameObject()
        }
    }
    
    var gameObject:PFObject = PFUser.currentUser()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSelectedShip = ""
        // create a new scene
        scene = SCNScene(named: "art.scnassets/Small Tropical Island.scn")!
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
                cameraNode.camera!.usesOrthographicProjection = true
                cameraNode.camera!.orthographicScale = 3;
                cameraNode.camera!.zNear = 0
                cameraNode.camera!.zFar = 100
                cameraNode.camera!.xFov = 30
                cameraNode.camera!.yFov = 30
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
        lightNode.light!.color = UIColor(white: 0.95, alpha: 1.0)
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.35, alpha: 1.0)
        //scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNodeWithName("Island", recursively: true)!
        
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 0)
        cameraNode.eulerAngles = SCNVector3Make(Float(-M_PI/2), 0, 0)
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
        
        
        let ship1 = scene.rootNode.childNodeWithName("Battleship1SupportGame", recursively: true)!
        
        let ship2 = scene.rootNode.childNodeWithName("Battleship1CrusierGame", recursively: true)!
        
        let ship3 = scene.rootNode.childNodeWithName("Battleship1CarrierGame", recursively: true)!
        
        let ship4 = scene.rootNode.childNodeWithName("Battleship2SupportGame", recursively: true)!
        
        let ship5 = scene.rootNode.childNodeWithName("Battleship2CrusierGame", recursively: true)!
        
        let ship6 = scene.rootNode.childNodeWithName("Battleship2CarrierGame", recursively: true)!
        
        worldNode.addChildNode(ship)
        worldNode.addChildNode(ship1)
        worldNode.addChildNode(ship2)
        worldNode.addChildNode(ship3)
        worldNode.addChildNode(ship4)
        worldNode.addChildNode(ship5)
        worldNode.addChildNode(ship6)
        
        worldNode.position.x = 0;
        worldNode.position.z = 0;
        scene.rootNode.addChildNode(worldNode)
        
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkTurn"), userInfo: nil, repeats: true)
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
        
        worldNode.position.x += Float(translation.x)/10
        worldNode.position.z += Float(translation.y)/10
        // worldNode.position.z += Float(view.center.y + translation.y)/worldNode.position.z
        //CGPoint(x:view.center.x + translation.x,
        //   y:view.center.y + translation.y)
        //var point = rotateGesture.locationInView()
        //var currentTrans = sender.view.transform
        //var newTrans = CGAffineTransformRotate(currentTrans, rotation)
        //sender.view.transform = newTrans
        //lastRotation = sender.rotation
    }
    
    func checkTurn(){
        do{
            try self.gameObject = PFQuery.getObjectOfClass("Game", objectId: self.gameObject.objectId!)
        } catch {
            print("Error on checkTurn")
        }
        if(self.gameObject["turn"] as! Bool == self.player1 && notCheckedTurn){
            self.yourTurn = true
            self.notCheckedTurn = false
            updateGame()
        }
    }
    
    func updateGame(){
        let ship = scene.rootNode.childNodeWithName(self.gameObject["ship"] as! String, recursively: true)
        if(ship != nil){
        if(self.gameObject["attack"] as! Bool){
            if(moved){
                doDamage()
            }
        } else{
            let newXPos = self.gameObject["x"] as! Float
            let newZPos = self.gameObject["z"] as! Float
            if(ship?.position.x != newXPos){
                if(newXPos < 0){
                    moveShipLeft()
                }
                if(newXPos > 0){
                    moveShipRight()
                }
            }
            if(ship?.position.z != newZPos){
                if(newZPos < 0){
                    moveShipForward()
                }
                if(newZPos > 0){
                    moveShipBack()
                }
            }
        }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let cameraOrbit = scene.rootNode.childNodeWithName("CameraOrbit", recursively: true)
        let scrollWidthRatio = Float(scrollView.contentOffset.x / scrollView.frame.size.width)
        let scrollHeightRatio = Float(scrollView.contentOffset.y / scrollView.frame.size.height)
        cameraOrbit!.eulerAngles.y = Float(-2 * M_PI) * scrollWidthRatio
        cameraOrbit!.eulerAngles.x = Float(-M_PI) * scrollHeightRatio
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        if(yourTurn){
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
            if(player1 && selectedNode.name!.containsString("2") || player1 == false && selectedNode.name!.containsString("1")){
                return
            }else{
            if(selectedNode.name!.containsString("Battleship")){
                lastSelectedShip = selectedNode.name!
                lastSelectedShip += "Game"
                if(gameObject["attack"] as! Bool){
                    gameObject["attackedShip"] = lastSelectedShip
                    doDamage()
                }
            }
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
        }
    }
    
    func doDamage(){
        var shipSunk = ""
        var shipAttacked = gameObject["attackedShip"] as! String
        let ship = scene.rootNode.childNodeWithName(shipAttacked, recursively: true)
        if(ship != nil){
            ShipsHealth.updateValue(ShipsHealth[shipAttacked]! - attackDamage, forKey: shipAttacked)
            if(ShipsHealth[shipAttacked]! <= 0){
                shipSunk = destroyShip(ship!)
            }
        }
        SendAttackDataToParse(shipSunk)
        notCheckedTurn = true
    }


    func SendAttackDataToParse(lastShipSunk: String){
        
        if(player1 == true){
            gameObject["turn"] = false
        } else{
            gameObject["turn"] = true
        }
        if( gameObject["attack"] as! Bool){
            gameObject["attackedShip"] = lastSelectedShip
        }
        gameObject["shipsunk"] = lastShipSunk
        gameObject["attack"] = false
        gameObject["ship"] = playersAttackingShip
        gameObject.saveInBackground()
        notCheckedTurn = true
        moved = false
    }
    
    func SendMoveDataToParse(x: Float, z: Float){
        if(player1 == true){
            gameObject["turn"] = false
        } else{
            gameObject["turn"] = true
        }
        gameObject["x"] = x
        gameObject["z"] = z
        gameObject["ship"] = lastSelectedShip
        gameObject["attack"] = false
        gameObject.saveInBackground()
        notCheckedTurn = true
        moved = false
    }
    
    func destroyShip(ship: SCNNode) -> String{
        let moveUp = SCNAction.moveByX(0.0, y: -1.0, z: 0.0, duration: 2.0)
        ship.pivot = SCNMatrix4MakeRotation(Float(M_PI_4*2), 1, 0, 0)
        ship.runAction(moveUp)
        return lastSelectedShip
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
        moveShipForward()
        moved = true
    }
    
    func moveShipForward(){
        let ship = scene.rootNode.childNodeWithName(gameObject["ship"] as! String, recursively: true)
        
        if(ship != nil){
            // let rotate = SCNAction.rotateToAxisAngle(<#T##axisAngle: SCNVector4##SCNVector4#>, duration: <#T##NSTimeInterval#>)
            let moveUp = SCNAction.moveByX(0.0, y: 0.0, z: -1.0, duration: 1.0)
            //ship!.runAction(rotate)
            ship?.pivot = SCNMatrix4MakeRotation(Float(M_PI_2*2), 0, 1, 0)
            ship!.runAction(moveUp)
        }
        if(moved){
            SendMoveDataToParse(Float(0.0), z: Float(-1.0))
        }
    }
    
    @IBAction func leftMovementAction(sender: AnyObject) {
        moveShipLeft()
        moved = true
    }
    
    func moveShipLeft(){
        let ship = scene.rootNode.childNodeWithName(gameObject["ship"] as! String, recursively: true)
        if(ship != nil){
            let moveUp = SCNAction.moveByX(-1.0, y: 0.0, z: 0.0, duration: 1.0)
            ship?.pivot = SCNMatrix4MakeRotation(Float(-M_PI_2), 0, 1, 0)
            ship!.runAction(moveUp)
        }
        if(moved){
            SendMoveDataToParse(Float(-1.0), z: Float(0.0))
        }
    }
    
    @IBAction func backMovementAction(sender: AnyObject) {
        moveShipBack()
        moved = true
    }
    
    func moveShipBack(){
        let ship = scene.rootNode.childNodeWithName(gameObject["ship"] as! String, recursively: true)
        if(ship != nil){
            let moveUp = SCNAction.moveByX(0.0, y: 0.0, z: 1.0, duration: 1.0)
            ship?.pivot = SCNMatrix4MakeRotation(Float(M_PI_2*4), 0, 1, 0)
            ship!.runAction(moveUp)
        }
        if(moved){
            SendMoveDataToParse(Float(0.0), z: Float(1.0))
        }
    }
    
    @IBAction func rightMovementAction(sender: AnyObject) {
        moveShipRight()
        moved = true
    }
    
   func moveShipRight(){
        let ship = scene.rootNode.childNodeWithName(gameObject["ship"] as! String, recursively:     true)
        if(ship != nil){
        let moveUp = SCNAction.moveByX(1.0, y: 0.0, z: 0.0, duration: 1.0)
        ship?.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 0, 1, 0)
        ship!.runAction(moveUp)
    
        }
    if(moved){
        SendMoveDataToParse(Float(1.0), z: Float(0.0))
    }
    }
    
    
    @IBAction func attackButtonAction(sender: AnyObject) {
        attackDamage = ShipsDamage[lastSelectedShip]!
        playersAttackingShip = lastSelectedShip
        moved = true
        gameObject["attack"] = true
        gameObject.saveInBackground()
    }
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        self.controllerView.hidden = true
        lastSelectedShip = ""
    }
    
    func createGameObject(){
        
        let game = PFObject(className: "Game")
        game["player1"] = PFUser.currentUser()
        game["player2"] = player2Id
        game["turn"] = false
        game["ship"] = ""
        game["x"] = 0.0
        game["z"] = 0.0
        game["attack"] = false
        game["attackedShip"] = ""
        game.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.gameObject = game
                print("GameId "+self.gameObject.objectId!)
            }
        }
    }
    
    func gameLost(){
        let uiAlert = UIAlertController(title: "Game Over", message: "You have no ships left, you lose.", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            PFUser.currentUser()!["losses"] = PFUser.currentUser()!["losses"] as! Int + 1
                PFUser.currentUser()!.saveInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo["error"] as? NSString
                        print(errorString)
                    }
                }
        
        }))
    }
    
    func gameWon(){
        let uiAlert = UIAlertController(title: "Game Over", message: "You have sunk your opponent, you win!", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            PFUser.currentUser()!["wins"] = PFUser.currentUser()!["wins"] as! Int + 1
            PFUser.currentUser()!.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    print(errorString)
                }
            }
        }))
    }
}