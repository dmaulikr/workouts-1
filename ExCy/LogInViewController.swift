//
//  LogInViewController.swift
//  ExCy
//
//  Created by Luke Regan on 7/17/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Firebase

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
		if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
			self.performSegueWithIdentifier("login", sender: nil)
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
			DataSerice.ds.REF_BASE.authUser(emailTextField.text!, password: passwordTextField.text, withCompletionBlock: { (error, data) -> Void in
				self.activityIndicator.stopAnimating()
				UIApplication.sharedApplication().endIgnoringInteractionEvents()
				if error != nil {
					if error.code == -8 {
						self.displayAlert("User does not exist", message: "Problem logging in. Please try a different email address or password")
					} else {
						self.displayAlert("Error", message: "Problem logging in. Please try a different email address or password")
					}
				} else {
					NSUserDefaults.standardUserDefaults().setValue(data.uid, forKey: KEY_UID)
					self.performSegueWithIdentifier("login", sender: nil)
				}
			})
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toWebView" {
			if let detailVC: VideosAndTipsViewController = segue.destinationViewController as? VideosAndTipsViewController {
				detailVC.tipURL = "http://excy.com"
			}
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
			DataSerice.ds.REF_BASE.resetPasswordForUser((alertController.textFields!.first)!.text!, withCompletionBlock: { (error) -> Void in
				if error == nil {
					self.displayAlert("email sent", message: "please check your email to reset your password")
				} else {
					self.displayAlert("Error", message: "Please try again")
				}
			})
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
