//
//  LogInViewController.swift
//  ExCy
//
//  Created by Luke Regan on 7/17/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

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
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.DismissKeyboard))
		view.addGestureRecognizer(tap)
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if UserDefaults.standard.value(forKey: KEY_UID) != nil {
			self.performSegue(withIdentifier: "login", sender: nil)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
	@IBAction func logInButtonPressed(_ sender: AnyObject) {
		if emailTextField.text == nil || passwordTextField.text == nil {
			displayAlert("Error", message: "Please enter a username and password")
		} else {
			beginActivityIndicator()
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                if error != nil {
                    self.displayAlert("Error", message: "Problem logging in. Please try a different email address or password")
                } else {
                    UserDefaults.standard.setValue(user?.uid, forKey: KEY_UID)
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
            })
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toWebView" {
			if let detailVC: VideosAndTipsViewController = segue.destination as? VideosAndTipsViewController {
				detailVC.tipURL = "http://excy.com"
			}
		}
	}
	
	@IBAction func forgotPassword(_ sender: UIButton) {
		let alertController = UIAlertController(title: "ForgotPassword?", message: "enter the email address you used to sign up with Excy", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "skip", style: .destructive) { action in }
		alertController.addTextField { (textField) -> Void in
			textField.placeholder = "User Email Address"
			textField.keyboardType = .emailAddress
		}
		let OKAction = UIAlertAction(title: "Enter", style: .cancel) { action in
            FIRAuth.auth()?.sendPasswordReset(withEmail: (alertController.textFields!.first)!.text!, completion: { (error) in
                if error == nil {
                    self.displayAlert("email sent", message: "please check your email to reset your password")
                } else {
                    self.displayAlert("Error", message: "Please try again")
                }
            })
		}
		alertController.addAction(OKAction)
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
		
	}
	
	func displayAlert(_ title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
			self.dismiss(animated: true, completion: nil)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func beginActivityIndicator() {
		activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
		UIApplication.shared.beginIgnoringInteractionEvents()
	}
	
	func DismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}

}
