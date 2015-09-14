//
//  LogInViewController.swift
//  ExCy
//
//  Created by Luke Regan on 7/17/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse

var workouts:[Workouts] = []

class LogInViewController: UIViewController {

	@IBOutlet var emailAddressTextField: UITextField!
	@IBOutlet var emailTextField: UITextField! // actually username text field. change later
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var mainLogInButton: UIButton!
	@IBOutlet var altButtonPressed: UIButton!
	@IBOutlet var helperTextLabel: UILabel!
	
	var isSignUpMode = true
	var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
		
    }
	
	override func viewDidAppear(animated: Bool) {
		navigationController?.removeFromParentViewController()
		var currentUser = PFUser.currentUser()
		if  currentUser != nil {
			performSegueWithIdentifier("login", sender: self)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func logInButtonPressed(sender: AnyObject) {
		if emailTextField.text == "" || passwordTextField.text == "" {
			
			displayAlert("Error", message: "Please enter a username and password")
			
		} else {
			
			beginActivityIndicator()
			
			var errorMessage = "Please try again later"
			
			if isSignUpMode == true {
				var user = PFUser()
				user.username = emailTextField.text
				user.password = passwordTextField.text
				user.email = emailAddressTextField.text
				user.signUpInBackgroundWithBlock({ (success, error) -> Void in
					
					self.activityIndicator.stopAnimating()
					UIApplication.sharedApplication().endIgnoringInteractionEvents()
					
					if error == nil {
						self.performSegueWithIdentifier("login", sender: self)
					} else {
						if let errorString = error!.userInfo?["error"] as? String {
							errorMessage = errorString
							
						}
						self.displayAlert("Failed SignUp", message: errorMessage)
					}
				})
			} else {
				
				PFUser.logInWithUsernameInBackground(emailTextField.text, password: passwordTextField.text, block: { (user, error) -> Void in
					
					self.activityIndicator.stopAnimating()
					UIApplication.sharedApplication().endIgnoringInteractionEvents()
					
					if user != nil {
						self.performSegueWithIdentifier("login", sender: self)
					} else {
						if let errorString = error!.userInfo?["error"] as? String {
							errorMessage = errorString
						}
						self.displayAlert("Failed SignUp", message: errorMessage)
					}
				})
			}
			
		}
	}

	@IBAction func signUpButtonPressed(sender: AnyObject) {
		if isSignUpMode == true {
			mainLogInButton.setTitle("Log In", forState: .Normal)
			helperTextLabel.text = "Not registerd?"
			altButtonPressed.setTitle("Sign Up", forState: .Normal)
			emailAddressTextField.hidden = true
			isSignUpMode = false
		} else {
			mainLogInButton.setTitle("Sign Up", forState: .Normal)
			helperTextLabel.text = "Already Registered?"
			altButtonPressed.setTitle("Log In", forState: .Normal)
			emailAddressTextField.hidden = false
			isSignUpMode = true
		}
	}
	
	
	func displayAlert(title: String, message: String) {
		var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
