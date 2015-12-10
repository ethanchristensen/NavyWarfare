//
//  BackgroundViewController.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 12/2/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//

import UIKit

class BackgroundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = NSBundle.mainBundle().pathForResource("OceanBack", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: "utf-8", baseURL: NSURL())
        
        webViewBG.userInteractionEnabled = false;
        self.view.insertSubview(webViewBG,atIndex:0);
        
        let filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.blackColor()
        filter.alpha = 0.05
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
