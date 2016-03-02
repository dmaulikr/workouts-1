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
	
	let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String

	@IBOutlet var ProfileImageView: UIImageView!
	@IBOutlet var emailAddressTextField: UITextField!
	@IBOutlet var signMeUpLabel: UILabel!
	@IBOutlet var caloriesPerWeekLabel: UITextField!
	@IBOutlet var workoutsPerWeekLabel: UITextField!
	@IBOutlet var myFitnessManifestoTextView: UITextView!
	
	var willSelectInspirationalImage = true
	
	var userGoals = [String:AnyObject]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = false

		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
    }
	
	override func viewDidAppear(animated: Bool) {
		
		DataSerice.ds.REF_USERS.childByAppendingPath(uid).observeEventType(.Value, withBlock: { snapshot in
			if let snapshot = snapshot.value as? [String: AnyObject] {
				self.userGoals = snapshot
				print(self.userGoals)
			}
			self.updatePersonalProfile()
		})
	}
	
	func updatePersonalProfile() {
		if let emailAddress = userGoals["email"] as? String { emailAddressTextField.text = emailAddress }
		if let caloriesGoal = userGoals["calorieGoal"] as? String { caloriesPerWeekLabel.text = caloriesGoal }
		if let workoutsGoal = userGoals["workoutGoal"] as? String { workoutsPerWeekLabel.text = workoutsGoal }
		if let fitnessManifesto = userGoals["manifesto"] as? String {  myFitnessManifestoTextView.text = fitnessManifesto}
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
		
		if caloriesPerWeekLabel.text!.isEmpty {  } else {
			userGoals["calorieGoal"] = caloriesPerWeekLabel.text
		}
		if workoutsPerWeekLabel.text!.isEmpty {  } else {
			userGoals["workoutGoal"] = workoutsPerWeekLabel!.text
		}
		if myFitnessManifestoTextView.text.isEmpty { } else {
			userGoals["manifesto"] = myFitnessManifestoTextView!.text
		}
		DataSerice.ds.REF_USERS.childByAppendingPath(uid).updateChildValues(userGoals)
		
		navigationController?.popViewControllerAnimated(true)
		
	}
	
	@IBAction func logOutButtonPRessed(sender: AnyObject) {
		NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
		let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn")
		self.presentViewController(loginVC, animated: true, completion: nil)
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
