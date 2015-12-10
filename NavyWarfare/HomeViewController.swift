//
//  LoginViewController.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 11/12/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: BackgroundViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    @IBOutlet weak var userName: UILabel!
    
    
    let loginViewController = PFLogInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let filePath = NSBundle.mainBundle().pathForResource("OceanBack", ofType: "gif")
        //        let gif = NSData(contentsOfFile: filePath!)
        //
        //        let webViewBG = UIWebView(frame: self.view.frame)
        //        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: "utf-8", baseURL: NSURL())
        //
        //        webViewBG.userInteractionEnabled = false;
        //        self.view.insertSubview(webViewBG,atIndex:0);
        //
        //        let filter = UIView()
        //        filter.frame = self.view.frame
        //        filter.backgroundColor = UIColor.blackColor()
        //        filter.alpha = 0.05
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setup()
        
    }
    
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        let alert = UIAlertController(title: "Login Error", message: "Login Error", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        logInController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        print("Failed to sign up...")
    }
    
    func setup(){
        if PFUser.currentUser() == nil {
            
            let loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
            self.presentViewController(loginViewController, animated: true, completion: nil)
            
            let signupViewController = PFSignUpViewController()
            signupViewController.delegate = self
            
        }else{
            self.userName.text = "Loged In as " + (PFUser.currentUser()?.username)!
        }
        
    }
    
    @IBAction func logOutButtonAction(sender: UIButton) {
        PFUser.logOut()
        self.setup()
    }
    
    
    
}
