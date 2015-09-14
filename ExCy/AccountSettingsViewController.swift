//
//  AccountSettingsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 7/21/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse

class AccountSettingsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

	@IBOutlet var ProfileImageView: UIImageView!
	@IBOutlet var emailAddressTextField: UITextField!
	@IBOutlet var signMeUpLabel: UILabel!
	@IBOutlet var caloriesPerWeekLabel: UITextField!
	@IBOutlet var workoutsPerWeekLabel: UITextField!
	@IBOutlet var myFitnessManifestoTextView: UITextView!
	
	var defaults = NSUserDefaults.standardUserDefaults()
	
	var willSelectInspirationalImage = true
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		
		if let fitnessManifesto: AnyObject = defaults.valueForKey("FitnessManifesto"){
			myFitnessManifestoTextView.text = (fitnessManifesto as! String)
		}
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		if ((PFUser.currentUser()?.email?.isEmpty) == false){
			emailAddressTextField.hidden = true
			signMeUpLabel.hidden = true
		}
		
		var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
		
		
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(animated: Bool) {
		var currentUser = PFUser.currentUser()
		if  currentUser == nil {
			
			let LogInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn") as? UIViewController
			self.presentViewController(LogInVC!, animated: true, completion: nil)
			
		}
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func changeImage () {
		var image = UIImagePickerController()
		image.delegate = self
		image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		image.allowsEditing = false
		self.presentViewController(image, animated: true, completion: nil)
	}
	
	var changeSpecificImageNumber = 1
	
	@IBAction func changeInspirationalImage1(sender: UIButton) {
		willSelectInspirationalImage = true
		changeSpecificImageNumber = 1
		changeImage()
	}
	@IBAction func changeInspirationalImage2(sender: UIButton) {
		willSelectInspirationalImage = true
		changeSpecificImageNumber = 2
		changeImage()
	}
	@IBAction func changeInspirationalImage3(sender: UIButton) {
		willSelectInspirationalImage = true
		changeSpecificImageNumber = 3
		changeImage()
	}
	
	
	
	@IBAction func changeImageButtonPressed(sender: AnyObject) {
		willSelectInspirationalImage = false
		changeImage()
	}
	
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		if willSelectInspirationalImage {
			self.dismissViewControllerAnimated(true, completion: nil)
			var imageData = UIImageJPEGRepresentation(image, 0.6)
			if (changeSpecificImageNumber == 1) {
				NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "InspirationImage1")
			} else if (changeSpecificImageNumber == 2) {
				NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "InspirationImage2")
			} else if (changeSpecificImageNumber == 3) {
				NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "InspirationImage3")
			}
		} else {
			self.dismissViewControllerAnimated(true, completion: nil)
			let blueColor = UIColor(red: 50/255, green: 145/255, blue: 210/255, alpha: 1.0)
			let croppedImage = Toucan(image: image).maskWithRoundedRect(cornerRadius: 50.0, borderWidth: 15.0, borderColor: blueColor).image
			ProfileImageView.image = croppedImage
			var imageData = UIImageJPEGRepresentation(croppedImage, 0.6)
			NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "profileImage")
		}
	}
	

	@IBAction func saveAccountChangesButtonPressed(sender: UIButton) {
		
		if emailAddressTextField.text.isEmpty {  } else {
			PFUser.currentUser()?.email = "\(emailAddressTextField.text)" }
		if caloriesPerWeekLabel.text.isEmpty {  } else {
			defaults.setObject("\(caloriesPerWeekLabel.text)", forKey: "CaloriesPerWeek") }
		if workoutsPerWeekLabel.text.isEmpty {  } else {
			defaults.setObject("\(workoutsPerWeekLabel.text)", forKey: "WorkoutsPerWeek") }
		if myFitnessManifestoTextView.text.isEmpty { } else {
			defaults.setObject("\(myFitnessManifestoTextView.text)", forKey: "FitnessManifesto") }
		
		
		navigationController?.popViewControllerAnimated(true)
		
	}
	
	@IBAction func logOutButtonPRessed(sender: AnyObject) {
		PFUser.logOutInBackgroundWithBlock { (error) -> Void in
			if error == nil {
				let LogInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn") as? UIViewController
				self.presentViewController(LogInVC!, animated: true, completion: nil)
			} else {
				println("Error: \(error)")
			}
		}
		
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func DismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
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
