//
//  SignUpViewController.swift
//  ExCy
//
//  Created by Luke Regan on 11/16/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse
import Firebase

let KEY_UID = "uid"

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
	
	
	func checkIfFieldsFilled() -> (success: Bool, message: String) {
		guard ageTextField.text?.characters.count > 0 else { return (false, "Please enter age") }
		guard heightTextField.text?.characters.count > 0 else { return (false, "Please enter height") }
		guard weightTextField.text?.characters.count > 0 else { return (false, "Please enter weight") }
		guard emailAddressTextField.text?.characters.count > 0 else { return (false, "Please enter email address") }
		guard usernameTextField.text?.characters.count > 0 else { return (false, "Please enter username") }
		guard passwordTextField.text?.characters.count > 0 else { return (false, "Please enter password") }
		return (true, "")
	}
	
	override func viewDidAppear(animated: Bool) {
		
	}

	@IBAction func SignUpButtonPressed(sender: UIButton) {
		
		let gender = self.genderSelection.selectedSegmentIndex == 0 ? "female" : "male"
		
		let success = checkIfFieldsFilled()
		if success.success {
			
			DataSerice.ds.REF_BASE.createUser(emailAddressTextField.text!, password: passwordTextField.text!) { (error, result) -> Void in
				if error == nil {
					NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
					DataSerice.ds.REF_BASE.authUser(self.emailAddressTextField.text!, password: self.passwordTextField.text!) { error, data in
						if error == nil {
							let user: [String: AnyObject] = [
								"age": Int(self.ageTextField.text!)!,
								"height": Int(self.heightTextField.text!)!,
								"weight": Int(self.weightTextField.text!)!,
								"email": self.emailAddressTextField.text!,
								"username": self.usernameTextField.text!,
								"gender": gender,
								"memberSince": StringFromDate.stringFromDate(NSDate())
							]
							DataSerice.ds.createFirebaseUser(data.uid, user: user)
						}
					}
					self.performSegueWithIdentifier("landingPage", sender: self)
				} else {
					self.displayAlert("Could not create account", message: "Problem creating account. Please try something else")
				}
			}
		} else {
			displayAlert("Error", message: success.message )
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
	

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toWebView" {
			if let detailVC: VideosAndTipsViewController = segue.destinationViewController as? VideosAndTipsViewController {
				detailVC.tipURL = "http://excy.com"
			}
		}
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
