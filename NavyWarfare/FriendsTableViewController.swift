//
//  FriendsTableViewController.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 12/1/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//
import UIKit
import Parse

class FriendsTableViewController: BackgroundTableViewController {
    
    
    //var userList = [AnyObject]()
    var friendsList: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        insertNewObject(self, index: 0)
        
        loadFriends()
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
        return friendsList.count + 1
    }
    
    func loadFriends(){
        
        
        friendsList = []
        
        if(PFUser.currentUser()!["friendsList"] == nil){
            PFUser.currentUser()?.setObject(friendsList, forKey: "friendsList")
            PFUser.currentUser()?.saveInBackground()
        }else{
            
            friendsList = PFUser.currentUser()!["friendsList"] as! [String]
            
            
            //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //self.tableView.reloadData()
            //})
        }

        
//        let query : PFQuery = PFUser.query()!
//        query.whereKey("objectId", notEqualTo: (PFUser.currentUser()?.objectId)!)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) users.")
//                
//                
//                //self.userList = objects!
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.tableView.reloadData()
//                })
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//            
//            
//        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell: UITableViewCell
            headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath)
            return headerCell
        } else {
            let cell: FriendsTableViewCell
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FriendsTableViewCell
            print("Load Friend Cells")
            
            for userID in friendsList {
                do{
                    //let user: PFUser = try PFQuery.getUserObjectWithId(userID["objectId"] as! String)
//                    cell.username.text = user.username
//                    let wins = user["wins"] as? Int
//                    let losses = user["losses"] as? Int
//                    cell.wins.text = "\(wins!)"
//                    cell.losses.text = "\(losses!)"
                    
                } catch{
                    print("Error fetching user")
                }
            }

            return cell
        }
        
    }
    
    
//    
//    func getUser(userID: String) -> PFUser {
//        let object = PFObject(withoutDataWithClassName:"User", objectId:user.objectId)
//        object.fetchFromLocalDatastoreInBackground().continueWithBlock({
//            (task: BFTask!) -> AnyObject! in
//            if task.error != nil {
//                // There was an error.
//                return task
//            }
//            return task
//        })
//        
//        return object
//        
//    }
    
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
