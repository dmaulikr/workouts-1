//
//  LogInViewController.swift
//  ExCy
//
//  Created by Luke Regan on 7/17/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

	@IBOutlet var emailTextField: UITextField! // actually username text field. change later
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var mainLogInButton: UIButton!
	@IBOutlet var altButtonPressed: UIButton!
	@IBOutlet var helperTextLabel: UILabel!
	
	var isSignUpMode = true
	var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
		
    }
	
	override func viewDidAppear(animated: Bool) {
		navigationController?.removeFromParentViewController()
		let currentUser = PFUser.currentUser()
		if  currentUser != nil {
			performSegueWithIdentifier("login", sender: self)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func logInButtonPressed(sender: AnyObject) {
		if emailTextField.text == nil || passwordTextField.text == nil {
			
			displayAlert("Error", message: "Please enter a username and password")
			
		} else {
			beginActivityIndicator()
			
			var errorMessage = "Please try again later"
			PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passwordTextField.text!, block: { (user, error) -> Void in
				self.activityIndicator.stopAnimating()
				UIApplication.sharedApplication().endIgnoringInteractionEvents()
					
				if user != nil {
					self.performSegueWithIdentifier("login", sender: self)
				} else {
					if let errorString = error!.userInfo["error"] as? String {
						errorMessage = errorString
					}
					self.displayAlert("Failed SignUp", message: errorMessage)
				}
			})
		}
	}
	
	@IBAction func forgotPassword(sender: UIButton) {
		let alertController = UIAlertController(title: "ForgotPassword?", message: "enter the email address you used to sign up with Excy", preferredStyle: .Alert)
		let cancelAction = UIAlertAction(title: "skip", style: .Destructive) { action in }
		alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
			textField.placeholder = "User Email Address"
			textField.keyboardType = .EmailAddress
		}
		let OKAction = UIAlertAction(title: "Enter", style: .Cancel) { action in
			PFUser.requestPasswordResetForEmailInBackground((alertController.textFields!.first)!.text!)
		}
		alertController.addAction(OKAction)
		alertController.addAction(cancelAction)
		
		self.presentViewController(alertController, animated: true, completion: nil)
		
	}
	
	func displayAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
			self.dismissViewControllerAnimated(true, completion: nil)
		}))
		self.presentViewController(alert, animated: true, completion: nil)
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
	
	func DismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}

}
