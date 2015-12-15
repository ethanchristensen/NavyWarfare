//
//  LeaderboardTableViewController.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 12/7/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//
//  iOS Semester Project 2015.  ETHAN CHRISTENSEN & GERAD WEGENER

import UIKit
import Parse

class LeaderboardTableViewController: BackgroundTableViewController {
    
    var playerList = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        insertNewObject(self, index: 0)
        //self.refreshControl = refreshController
        //self.refreshControl?.addTarget(self, action: "didRefresh", forControlEvents: .ValueChanged)
        
        loadUsers()
    }
    func insertNewObject(sender: AnyObject, index: Int) {
        //   orderList.insert(, atIndex: 0)
        _ = (forRow: index, inSection: 0)
        //      self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playerList.count + 1
    }
    
    func loadUsers(){
        let query : PFQuery = PFUser.query()!
        //let query = PFQuery(className: "User")
        
        //query.whereKey("objectId", notEqualTo: (PFUser.currentUser()?.objectId)!)
        query.orderByDescending("wins")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
                // Do something with the found objects
                self.playerList = objects!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }  
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell: UITableViewCell
            headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath)
            return headerCell
        } else {
            let cell: LeaderboardTableViewCell
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LeaderboardTableViewCell
            print("Load Cells")
            if let user = playerList[indexPath.row-1] as? PFUser {
                
                
                if(user.objectId == PFUser.currentUser()?.objectId){
                    cell.startGameButton.hidden = true
                    cell.userInteractionEnabled = false
                }
                
//                do{
//                    try user = PFQuery.getUserObjectWithId(user.objectId!)
//                } catch{
//                    print("Error fetching user")
//                }
                
                let uname = user.username
                //let uname = object["username"] as? String
                
                if(user["wins"] == nil){
                    user["wins"] = 0
                    user["losses"] = 0
                    user.saveInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in
                        if let error = error {
                            let errorString = error.userInfo["error"] as? NSString
                            print(errorString)
                        }
                    }
                }
                
                let wins = user["wins"] as? Int
                let losses = user["losses"] as? Int
                cell.username.text = uname
                cell.wins.text = "\(wins!)"
                cell.losses.text = "\(losses!)"
                cell.hiddenObjectIdLabel.text = user.objectId
                
                
            }
            return cell
        }
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StartGameSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as? LeaderboardTableViewCell
                let controller = segue.destinationViewController as! GameViewController
              
                do{
                    try controller.player2Id = PFQuery.getUserObjectWithId((cell?.hiddenObjectIdLabel.text)!)
                } catch {
                    print("Error fetching Player2")
                }
                controller.player1 = true
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
}
