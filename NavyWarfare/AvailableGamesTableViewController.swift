//
//  AvailableGamesTableViewController.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 12/13/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//

import UIKit
import Parse

class AvailableGamesTableViewController: BackgroundTableViewController {
    
    var gameList = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        insertNewObject(self, index: 0)
        //self.refreshControl = refreshController
        //self.refreshControl?.addTarget(self, action: "didRefresh", forControlEvents: .ValueChanged)
        
        loadGames()
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
        return gameList.count + 1
    }
    
    func loadGames(){
        //let query : PFQuery = PFUser.query()!
        let query = PFQuery(className: "Game")
        
        query.whereKey("player2", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
                // Do something with the found objects
                self.gameList = objects!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            } else {
                // Log details of the failure
                //print("Error: \(error!) \(error!.userInfo)")
                print("Error fetching user")
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell: UITableViewCell
            headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath)
            return headerCell
        } else {
            let cell: AvailableGamesTableViewCell
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AvailableGamesTableViewCell
            print("Load Cells")
            if let object = gameList[indexPath.row-1] as? PFObject {
                
                var opponent = object["player1"] as! PFUser
                
                do{
                    try opponent = PFQuery.getUserObjectWithId(opponent.objectId!)
                } catch{
                    print("Error fetching user")
                }
                
                let uname = opponent.username
                let wins = opponent["wins"] as? Int
                let losses = opponent["losses"] as? Int
                cell.username.text = uname
                cell.wins.text = "\(wins!)"
                cell.losses.text = "\(losses!)"
                cell.hiddenObjectIdLabel.text = object.objectId
                
                
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
        if segue.identifier == "JoinGameSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as? AvailableGamesTableViewCell
                let controller = segue.destinationViewController as! GameViewController
                let game = gameList[indexPath.row-1] as? PFObject
                
                controller.gameObject = game!
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
}
