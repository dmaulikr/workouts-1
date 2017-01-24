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
import FirebaseAuth
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.DismissKeyboard))
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
	
	override func viewDidAppear(_ animated: Bool) {
		
	}

	@IBAction func SignUpButtonPressed(_ sender: UIButton) {
		
		let gender = self.genderSelection.selectedSegmentIndex == 0 ? "female" : "male"
		
		let success = checkIfFieldsFilled()
		if success.success {
            FIRAuth.auth()?.createUser(withEmail: emailAddressTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                UserDefaults.standard.setValue(user?.uid, forKey: KEY_UID)
                if error == nil {
                    let specs: [String: Any] = [
                        "age": Int(self.ageTextField.text!) ?? 30,
                        "height": Int(self.heightTextField.text!)!,
                        "weight": Int(self.weightTextField.text!)!,
                        "email": self.emailAddressTextField.text!,
                        "username": self.usernameTextField.text!,
                        "gender": gender,
                        "memberSince": StringFromDate.startStringFromDate(Date())
                    ]
                   DataSerice.ds.createFirebaseUser((user?.uid)!, user: specs)
                    self.performSegue(withIdentifier: "landingPage", sender: self)
                } else {
                    self.displayAlert("Could not create account", message: "Problem creating account. Please try something else")
                }
                
            })
		} else {
			displayAlert("Error", message: success.message )
		}
		
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
	

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toWebView" {
			if let detailVC: VideosAndTipsViewController = segue.destination as? VideosAndTipsViewController {
				detailVC.tipURL = "http://excy.com"
			}
		}
	}
	
	func displayAlert(_ title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
			
		}))
		self.present(alert, animated: true, completion: nil)
	}
	func DismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}

	


}
