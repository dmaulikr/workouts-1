//
//  SignUpViewController.swift
//  ExCy
//
//  Created by Luke Regan on 11/16/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
	
	
	
	@IBOutlet weak var genderSelection: UISegmentedControl!
	@IBOutlet weak var ageTextField: UITextField!
	@IBOutlet weak var heightTextField: UITextField!
	@IBOutlet weak var weightTextField: UITextField!
	@IBOutlet weak var emailAddressTextField: UITextField!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	
	var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
		
	}
	
	override func viewDidAppear(animated: Bool) {
		
	}

	@IBAction func SignUpButtonPressed(sender: UIButton) {
		
		if emailAddressTextField.text?.characters.count > 0 || passwordTextField.text?.characters.count > 0 || emailAddressTextField.text?.characters.count > 0 {
			
			self.activityIndicator.startAnimating()
			let user = PFUser()
			user.username = usernameTextField.text
			user.password = passwordTextField.text
			user.email = emailAddressTextField.text
			
			if genderSelection.selectedSegmentIndex == 0 { user["gender"] = "female"
			} else { user["gender"] = "male" }
			
			if heightTextField.text == nil { user["height"] = 67
			} else { user["height"] = Int(heightTextField.text!) }
			
			if weightTextField.text == nil { user["weight"] = 200
			} else { user["weight"] = Int(weightTextField.text!) }
			
			if ageTextField.text == nil { user["age"] = 30
			} else { user["age"] = Int(ageTextField.text!) }
			
			
			user.signUpInBackgroundWithBlock({ (success, error) -> Void in
				var errorMessage = "Please try again later"
				
				self.activityIndicator.stopAnimating()
				UIApplication.sharedApplication().endIgnoringInteractionEvents()
				
				if error == nil {
					self.performSegueWithIdentifier("landingPage", sender: self)
				} else {
					if let errorString = error!.userInfo["error"] as? String {
						errorMessage = errorString
						
					}
					self.displayAlert("Failed SignUp", message: errorMessage)
				}
			})

		} else {
			
			displayAlert("Error", message: "Please enter a username, password and email")
		}
		
	}
	
	
	func beginActivityIndicator() {
		activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
		view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
		UIApplication.sharedApplication().beginIgnoringInteractionEvents()
	}
	
	func displayAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
			
		}))
		self.presentViewController(alert, animated: true, completion: nil)
	}
	func DismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}

	


}
