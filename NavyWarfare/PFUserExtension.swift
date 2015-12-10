//
//  PFUserExtension.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 12/1/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//

import Parse

extension PFUser {
    
    
    
    func playerWins() -> Int {
        var wins = 0
        
        
        PFUser.currentUser()!.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
            wins = ((PFUser.currentUser()!.objectForKey("wins") as? Int) == nil) ? 0 : PFUser.currentUser()!.objectForKey("wins") as! Int
        }
        
        
        return wins
    }
    
    func playerLosses() -> Int {
        var losses = 0
        PFUser.currentUser()!.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
            losses = ((PFUser.currentUser()!.objectForKey("losses") as? Int) == nil) ? 0 : PFUser.currentUser()!.objectForKey("losses") as! Int
        }
        
        return losses
    }
    
    func friendsList() -> [String] {
        var friends:[String] = []
        PFUser.currentUser()!.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
            friends = ((PFUser.currentUser()!.objectForKey("friends") as? [String]) == nil) ? [] : PFUser.currentUser()!.objectForKey("friends") as! [String]
        }
        
        return friends
    }
    
    
    
}