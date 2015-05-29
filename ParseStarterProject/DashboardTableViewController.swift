//
//  DashboardTableViewController.swift
//  ParseStarterProject
//
//  Created by Li-Wei Tseng on 5/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class DashboardTableViewController: UITableViewController {

    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var drawViewFiles = [PFFile]()
    
    var refresher: UIRefreshControl!
    
    // fetch data from Parse.com and update the screen
    func refresh() {
        var query = PFQuery(className: "Post")
        
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                if let objects = objects {
                    // remove old data in local array, so there will no duplicate data when refresh
                    self.imageFiles.removeAll(keepCapacity: true)
                    self.messages.removeAll(keepCapacity: true)
                    self.usernames.removeAll(keepCapacity: true)
                    
                    for object in objects {
                        self.messages.append(object["message"] as! String)
                        self.usernames.append(object["username"] as! String)
                        self.imageFiles.append(object["imageFile"]! as! PFFile)
                        self.drawViewFiles.append(object["drawViewFile"] as! PFFile)
                      
                        self.tableView.reloadData()
                        self.refresher.endRefreshing()
                    }
                    // we retrieve data in reverse order, so we need to reverse them
                    self.messages = self.messages.reverse()
                    self.usernames = self.usernames.reverse()
                    self.imageFiles = self.imageFiles.reverse()
                    self.drawViewFiles = self.drawViewFiles.reverse()
                }
            } else {
                println("Error fetching data")
            }
        })
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        refresh()

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return messages.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DashboardCell
        
        // get data from local array and update IBOutlets
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            if let downloadedImage = UIImage(data: data!) {
                cell.postedImage.image = downloadedImage
            }
        }
        
        drawViewFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            if let downloadedImage = UIImage(data: data!) {
                cell.drawViewImage.image = downloadedImage
            }
        }
        
        cell.username.text = usernames[indexPath.row]
        cell.message.text = messages[indexPath.row]
        
        cell.userInteractionEnabled = false
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
