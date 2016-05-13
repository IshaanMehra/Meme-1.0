//
//  ViewController.swift
//  Meme1.0
//
//  Created by Ishaan Mehra on 08/05/16.
//  Copyright © 2016 Ishaan Mehra. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var CameraButton: UIBarButtonItem!
    @IBOutlet weak var UImage: UIImageView!
    
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    @IBOutlet weak var TopText: UITextField!

    @IBOutlet weak var BottomText: UITextField!
    
    var memedImage: UIImage!
    var memes: [Meme]!
 
    

    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TopText.text = "TOP"
        BottomText.text = "BOTTOM"
        ShareButton.enabled=false
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5,
        ]
        
        TopText.defaultTextAttributes = memeTextAttributes
        BottomText.defaultTextAttributes = memeTextAttributes
        
        TopText.textAlignment = .Center
        TopText.clearsOnBeginEditing = true
        
        BottomText.textAlignment = .Center
        BottomText.clearsOnBeginEditing = true
        
                // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    CameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.subscribeToKeyboardNotifications()
        
    
    }
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
        
    }
    
        @IBAction func PickAnImage(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion:nil)
            
            ShareButton.enabled=true

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UImage.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

  
  
    @IBAction func ClickAnImagee(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if BottomText.isFirstResponder(){
            
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if BottomText.isFirstResponder() {
            
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:" , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    ////////////////////////
    //text field functions//
    ////////////////////////
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = " "
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
        textField.text = String(newText)
        return false
    }
    
    struct Meme {
        
        var topTextField: String?
        var bottomTextField: String?
        var originalImage: UIImage?
        let memedImage: UIImage!
    }
    
    func save() {
        
        _ = Meme(topTextField: TopText.text!, bottomTextField: BottomText.text!, originalImage: UImage.image!, memedImage: memedImage)
    }
    func generateMemedImage() -> UIImage
    {
        ShareButton.enabled=true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    @IBAction func SharedButtonPressed(sender: UIButton) {
        // memed image to activity view
        self.memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [self.memedImage!],
            applicationActivities: nil)
        
        // Save image to shared
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
}

