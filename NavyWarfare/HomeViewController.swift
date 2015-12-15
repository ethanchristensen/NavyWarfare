//
//  LoginViewController.swift
//  NavyWarfare
//
//  Created by Ethan Christensen on 11/12/15.
//  Copyright © 2015 Ethan Christensen. All rights reserved.
//
//  iOS Semester Project 2015.  ETHAN CHRISTENSEN & GERAD WEGENER


import UIKit
import Parse
import ParseUI

class HomeViewController: BackgroundViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    @IBOutlet weak var userName: UILabel!
    
    
    let loginViewController = PFLogInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
