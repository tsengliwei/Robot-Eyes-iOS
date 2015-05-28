//
//  UploadViewController.swift
//  ParseStarterProject
//
//  Created by Li-Wei Tseng on 5/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
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

    
    /////////////// IB ////////////////////
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var drawView: DrawView!
    @IBOutlet var colorBtn: UIBarButtonItem!
    
    @IBAction func chooseFromPhotos(sender: AnyObject) {
        fetchPhotos("PhotoLibrary")
    }
    
    @IBAction func chooseFromCamera(sender: AnyObject) {
        fetchPhotos("Camera")
    }
    
    @IBAction func clearImage(sender: AnyObject) {
        var theDrawView: DrawView = drawView as DrawView
        if theDrawView.lines.count != 0 {
            theDrawView.lines = []
            theDrawView.setNeedsDisplay()
        } else {
            imageToPost.image = UIImage(named: "placeholder.jpg")
        }
    }
    
    @IBAction func changeColor(sender: AnyObject) {
        var theDrawView: DrawView = drawView as DrawView
        var color: UIColor!
        if colorBtn.title == "Black" {
            color = UIColor.blackColor()
            colorBtn.title = "White"
        } else if colorBtn.title == "White"{
            colorBtn.title = "Black"
            color = UIColor.whiteColor()
        }
        theDrawView.drawColor = color
    }
    
    @IBOutlet var message: UITextField!
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        if message.text == "" || imageToPost == nil {
            
            displayAlert("Error in form", message: "Please choose a photo and enter a message")
            
        } else {
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Post")
            
            post["message"] = message.text
            post["userId"] = PFUser.currentUser()!.objectId!
            post["username"] = PFUser.currentUser()?.username
            
            
            let imageData = UIImagePNGRepresentation(imageToPost.image)
            
            let imageFile = PFFile(name: "image.png", data: imageData)
            
            post["imageFile"] = imageFile
            
            let drawViewImage = imageWithVIew(drawView)
            
            let drawViewData = UIImagePNGRepresentation(drawViewImage)
            
            let drawViewFile = PFFile(name: "drawView.png", data: drawViewData)
            
            post["drawViewFile"] = drawViewFile
            
            
            post.saveInBackgroundWithBlock { (success, error) -> Void in
                self.activityIndicator.stopAnimating()
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    self.displayAlert("Image Posted", message: "Your image has been posted successfully")
                    
                    self.imageToPost.image = UIImage(named: "placeholder.jpg")
                    
                    self.message.text = ""
                    
                    
                } else {
                    self.displayAlert("Could not post image", message: (error!.userInfo?["error"] as? String)!)
                }
            }
        }
        

    }
    
    /////////////// IB ////////////////////

    
    ////////////// Helpers ///////////////
    func fetchPhotos(way: String){
        var image = UIImagePickerController()
        image.delegate = self
        if way == "PhotoLibrary" {
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else if way == "Camera" {
            image.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        image.allowsEditing = false;
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String){
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    var activityIndicator = UIActivityIndicatorView()

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = imageResize(image, sizeChange: imageToPost.image!.size)
    }
    
    func imageWithVIew(view: UIView) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        var img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }

    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    ////////////// Helpers ///////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.message.delegate = self
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
