//
//  LoginViewController.swift
//  ParseStarterProject
//
//  Created by Li-Wei Tseng on 5/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    ////////////// Control Keyboard/////////////////
    func textFieldDidBeginEditing(textField: UITextField) { // became first responder
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.mainScreen().bounds
        let keyboardHeight : CGFloat = 256
        
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:NSTimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height + */UIApplication.sharedApplication().statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.sharedApplication().statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:NSTimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    ////////////// Control Keyboard/////////////////
    
    var signupActive = false

    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var accessButton: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    @IBOutlet var switchButton: UIButton!
    
    var activityIndicator =  UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String){
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchMode(sender: AnyObject) {
        if signupActive {
            accessButton.setTitle("Log in", forState: UIControlState.Normal)
            registeredText.text = "Not registered?"
            
            switchButton.setTitle("Register", forState: UIControlState.Normal)
            
            signupActive = false
        } else {
            accessButton.setTitle("Register", forState: UIControlState.Normal)
            registeredText.text = "Already registered?"
            
            switchButton.setTitle("Log in", forState: UIControlState.Normal)
            
            signupActive = true

        }
    }
    
    @IBAction func access(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Error in form", message: "Please enter a username and password")
            
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"

            if signupActive {
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        // Signup successful
                       self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        if let errorString = error!.userInfo?["error"] as? String {
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed Register", message: errorMessage)
                    }
                })
            } else {
                    PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: { (user, error) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if user != nil {
                            // Logged in!
                            self.performSegueWithIdentifier("login", sender: self)
                            
                        } else {
                            if let errorString = error!.userInfo?["error"] as? String {
                                errorMessage = errorString
                            }
                            
                            self.displayAlert("Failed Login", message: errorMessage)
                        }
                    })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.delegate = self
        self.password.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.objectId != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
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
