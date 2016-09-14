//
//  AccountSettingsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 7/21/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse
import Alamofire

class AccountSettingsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	@IBOutlet var ProfileImageView: UIImageView!
	@IBOutlet var emailAddressTextField: UITextField!
	@IBOutlet var signMeUpLabel: UILabel!
	@IBOutlet var caloriesPerWeekLabel: UITextField!
	@IBOutlet var workoutsPerWeekLabel: UITextField!
	@IBOutlet var myFitnessManifestoTextView: UITextView!
	@IBOutlet weak var inspiringButtonOne: UIButton!
	@IBOutlet weak var inspiringButtonTwo: UIButton!
	@IBOutlet weak var inspiringButtonThree: UIButton!
	
	var willSelectInspirationalImage = true
	
	var userGoals = [String:AnyObject]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = false

		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
    }
	
	override func viewDidAppear(animated: Bool) {
		
		guard let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn")
			self.presentViewController(loginVC, animated: true, completion: nil)
			return
		}
		
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
			if (changeSpecificImageNumber == 1) {
				saveImage(image, named: "inspiringImage1")
				inspiringButtonOne.backgroundColor = UIColor.clearColor()
				inspiringButtonOne.setBackgroundImage(image, forState: .Normal)
			} else if (changeSpecificImageNumber == 2) {
				saveImage(image, named: "inspiringImage2")
				inspiringButtonTwo.backgroundColor = UIColor.clearColor()
				inspiringButtonTwo.setBackgroundImage(image, forState: .Normal)
			} else if (changeSpecificImageNumber == 3) {
				saveImage(image, named: "inspiringImage3")
				inspiringButtonThree.backgroundColor = UIColor.clearColor()
				inspiringButtonThree.setBackgroundImage(image, forState: .Normal)
			}
		} else {
			ProfileImageView.image = image
			saveImage(image, named: "profileImageUrl")
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	func saveImage(image: UIImage, named: String) {
		
		guard let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn")
			self.presentViewController(loginVC, animated: true, completion: nil)
			return
		}
		let urlStr = "https://post.imageshack.us/upload_api.php"
		let url = NSURL(string: urlStr)!
		let imageData = UIImageJPEGRepresentation(image, 0.2)!
		let keyData = "2679GJMV25b978622f28e584f5e6e432b7af8e82".dataUsingEncoding(NSUTF8StringEncoding)!
		let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
		Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
			multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
			multipartFormData.appendBodyPart(data: keyData, name: "key")
			multipartFormData.appendBodyPart(data: keyJSON, name: "format")
			}) { encodingResult in
				switch encodingResult {
				case .Success(let upload, _, _) :
					print(upload)
					upload.responseJSON { response in
						
						guard response.result.isSuccess else {
							print("shit went down \(response.result.error)")
							print(response.result.description )
							print("shit went down \(response.result.value)")
							return
						}
						guard let responseJSON = response.result.value as? [String: AnyObject],
						links = responseJSON["links"] as? [String: AnyObject],
						imgLink = links["image_link"] as? String else {
							print("shits on fire yo")
							return
						}
						self.userGoals[named] = imgLink
						DataSerice.ds.REF_USERS.childByAppendingPath(uid).updateChildValues(self.userGoals)
//						if let info = response.result.value as? [String: AnyObject] {
//							if let links = info["links"] as? [String: AnyObject] {
//								if let imgLink = links["image_link"] as? String {
//									let newImage = [named: imgLink]
//									self.userGoals[named] = imgLink
//									DataSerice.ds.REF_USERS.childByAppendingPath(uid).updateChildValues(newImage)
//								}
//							}
//						}
					}
				case .Failure(let error):
					print(error)
				}
		}
	}
	

	@IBAction func saveAccountChangesButtonPressed(sender: UIButton) {
		
		guard let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn")
			self.presentViewController(loginVC, animated: true, completion: nil)
			return
		}
		
		if caloriesPerWeekLabel.text!.isEmpty {  } else {
			userGoals["calorieGoal"] = caloriesPerWeekLabel.text
		}
		if workoutsPerWeekLabel.text!.isEmpty {  } else {
			userGoals["workoutGoal"] = workoutsPerWeekLabel!.text
		}
		if myFitnessManifestoTextView.text.isEmpty { } else {
			userGoals["manifesto"] = myFitnessManifestoTextView!.text
		}
		print(self.userGoals)
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
