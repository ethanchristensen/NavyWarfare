//
//  TodayViewController.swift
//  TodayGameExtension
//
//  Created by Ethan Christensen on 12/10/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//

import UIKit
import NotificationCenter
import Parse
import Bolts

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var expanded: Bool = false
    var gameList = [AnyObject]()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var directionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Parse.isLocalDatastoreEnabled() == false
        {
            Parse.enableLocalDatastore()
            
            Parse.setApplicationId("ZW73bRK1nYI8Ysdm3rkzyz2ALhtBZw4WhsXcVRjv",
                clientKey: "2Vow6rlpdNPVwxqqryyda54M5lpEHGnGs5w8WOyS")
        }
        
        self.preferredContentSize = CGSizeMake(0, 50)
        self.loadGames()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsZero
    }
    
    func loadGames(){
        //let query : PFQuery = PFUser.query()!
        let query = PFQuery(className: "Game")
        
        //query.whereKey("player2", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
                // Do something with the found objects
                self.gameList = objects!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.setStatus()
                })
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func setStatus(){
        if(gameList.count == 0){
            self.statusLabel.text = "There are no available games."
            self.directionLabel.text = "Open Leaderboard to invite players to battle!"
        }else if(gameList.count == 1){
            self.statusLabel.text = "There is one new game request!"
            self.directionLabel.text = "Open Available Games to battle!"
        }else{
            self.statusLabel.text = "There are \(gameList.count) new game requests!"
            self.directionLabel.text = "Open Available Games to battle!"
        }
    }
    
    @IBAction func showMore(sender: UIButton) {
        if self.expanded {
            self.preferredContentSize = CGSizeMake(0, 50)
            showMoreButton.transform = CGAffineTransformMakeRotation(0)
            self.expanded = false
        } else {
            self.preferredContentSize = CGSizeMake(0, 270)
            showMoreButton.transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
            self.expanded = true
        }
    }
    
    @IBAction func returnToGame(sender: AnyObject) {
        let url = NSURL(string: "navyWarfare://")
        self.extensionContext?.openURL(url!, completionHandler: nil)
    }
    
}