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
	
	var willSelectInspirationalImage = true
	
	var userGoals = PFObject(className: "UserGoals")
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		if ((PFUser.currentUser()?.email?.isEmpty) == false){
			emailAddressTextField.hidden = true
			signMeUpLabel.hidden = true
		}
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
    }
	
	override func viewDidAppear(animated: Bool) {
		let currentUser = PFUser.currentUser()
		if  currentUser == nil {
			
			let LogInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn") 
			self.presentViewController(LogInVC, animated: true, completion: nil)
			
		} else {
			
			userGoals["username"] = PFUser.currentUser()!.username
			let query = PFQuery(className: "UserGoals")
			query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
			query.getFirstObjectInBackgroundWithBlock({ object, error in
				if error == nil {
					self.userGoals = object!
					if let fitnessManifesto: String = object!["manifesto"] as? String {
						self.myFitnessManifestoTextView.text = fitnessManifesto
					}
					if let workoutGoal: String = object!["workoutGoal"] as? String {
						self.workoutsPerWeekLabel.text = workoutGoal
					}
					if let calorieGoal: String = object!["calorieGoal"] as? String {
						self.caloriesPerWeekLabel.text = calorieGoal
					}
					if let profileImage = object!["profileImage"] as? PFFile {
						profileImage.getDataInBackgroundWithBlock {
							(imageData: NSData?, error: NSError?) -> Void in
							if error == nil {
								if let imageData = imageData { self.ProfileImageView.image = UIImage(data: imageData) }
							}
						}
					}
				} else {
				}
			})
		}
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// Image changing code
	func changeImage () {
		let image = UIImagePickerController()
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
			let imageData = UIImageJPEGRepresentation(image, 0.6)
			if (changeSpecificImageNumber == 1) {
				let parseImage = PFFile(name: "inspirationalImageOne", data: imageData!)
				userGoals["inspirationalImageOne"] = parseImage
			} else if (changeSpecificImageNumber == 2) {
				let parseImage = PFFile(name: "inspirationalImageTwo", data: imageData!)
				userGoals["inspirationalImageTwo"] = parseImage
			} else if (changeSpecificImageNumber == 3) {
				let parseImage = PFFile(name: "inspirationalImageThree", data: imageData!)
				userGoals["inspirationalImageThree"] = parseImage
			}
		} else {
			ProfileImageView.image = image
			let imageData = UIImageJPEGRepresentation(image, 0.6)
			let parseImage = PFFile(name: "profileImage", data: imageData!)
			userGoals["profileImage"] = parseImage
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	

	@IBAction func saveAccountChangesButtonPressed(sender: UIButton) {
		
		if emailAddressTextField.text!.isEmpty {  } else {
			PFUser.currentUser()?.email = "\(emailAddressTextField.text)" }
		if caloriesPerWeekLabel.text!.isEmpty {  } else {
			userGoals["calorieGoal"] = caloriesPerWeekLabel.text
		}
		if workoutsPerWeekLabel.text!.isEmpty {  } else {
			userGoals["workoutGoal"] = workoutsPerWeekLabel!.text
		}
		if myFitnessManifestoTextView.text.isEmpty { } else {
			userGoals["manifesto"] = myFitnessManifestoTextView!.text
		}
		userGoals.saveInBackgroundWithBlock { (success, error) -> Void in
			if success {
				self.navigationController?.popViewControllerAnimated(true)
			} else {
				self.navigationController?.popViewControllerAnimated(true)
			}
		}
		
		
		navigationController?.popViewControllerAnimated(true)
		
	}
	
	@IBAction func logOutButtonPRessed(sender: AnyObject) {
		PFUser.logOutInBackgroundWithBlock { (error) -> Void in
			if error == nil {
				let LogInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn") as UIViewController
				self.presentViewController(LogInVC, animated: true, completion: nil)
			} else {
				print("Error: \(error)\n Please try again")
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
