//
//  AccountViewController.swift
//  ParseStarterProject
//
//  Created by Li-Wei Tseng on 5/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class AccountViewController: UIViewController {

    @IBOutlet var username: UILabel!
    
    @IBOutlet var id: UILabel!
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if error == nil {
                println("PF logout succeeds")
            } else {
                println("PF logout fail")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if PFUser.currentUser()?.objectId != nil {
            id.text = PFUser.currentUser()!.objectId!
            username.text = PFUser.currentUser()?.username            
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
