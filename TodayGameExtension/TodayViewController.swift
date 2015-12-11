//
//  TodayViewController.swift
//  TodayGameExtension
//
//  Created by Ethan Christensen on 12/10/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var expanded: Bool = false
    
    @IBOutlet weak var showMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(0, 50)
//        self.loadVideos()
//        self.containerSubView!.hidden = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsZero
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
        //self.containerSubView!.hidden = !self.expanded
    }
    
    @IBAction func returnToGame(sender: AnyObject) {
        let url = NSURL(string: "navyWarfare://")
        self.extensionContext?.openURL(url!, completionHandler: nil)
    }
    
}
