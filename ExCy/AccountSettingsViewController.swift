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

		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccountSettingsViewController.DismissKeyboard))
		view.addGestureRecognizer(tap)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		guard let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
			self.present(loginVC, animated: true, completion: nil)
			return
		}
		
		DataSerice.ds.REF_USERS.child(byAppendingPath: uid).observe(.value, with: { snapshot in
			if let snapshot = snapshot?.value as? [String: AnyObject] {
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
		image.sourceType = UIImagePickerControllerSourceType.photoLibrary
		image.allowsEditing = false
		self.present(image, animated: true, completion: nil)
	}
	
	var changeSpecificImageNumber = 1
	
	@IBAction func changeInspirationalImage1(_ sender: UIButton) {
		willSelectInspirationalImage = true
		changeSpecificImageNumber = 1
		changeImage()
	}
	@IBAction func changeInspirationalImage2(_ sender: UIButton) {
		willSelectInspirationalImage = true
		changeSpecificImageNumber = 2
		changeImage()
	}
	@IBAction func changeInspirationalImage3(_ sender: UIButton) {
		willSelectInspirationalImage = true
		changeSpecificImageNumber = 3
		changeImage()
	}
	
	@IBAction func changeImageButtonPressed(_ sender: AnyObject) {
		willSelectInspirationalImage = false
		changeImage()
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
		if willSelectInspirationalImage {
			self.dismiss(animated: true, completion: nil)
			if (changeSpecificImageNumber == 1) {
				saveImage(image, named: "inspiringImage1")
				inspiringButtonOne.backgroundColor = UIColor.clear
				inspiringButtonOne.setBackgroundImage(image, for: UIControlState())
			} else if (changeSpecificImageNumber == 2) {
				saveImage(image, named: "inspiringImage2")
				inspiringButtonTwo.backgroundColor = UIColor.clear
				inspiringButtonTwo.setBackgroundImage(image, for: UIControlState())
			} else if (changeSpecificImageNumber == 3) {
				saveImage(image, named: "inspiringImage3")
				inspiringButtonThree.backgroundColor = UIColor.clear
				inspiringButtonThree.setBackgroundImage(image, for: UIControlState())
			}
		} else {
			ProfileImageView.image = image
			saveImage(image, named: "profileImageUrl")
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	func saveImage(_ image: UIImage, named: String) {
		
		guard let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
			self.present(loginVC, animated: true, completion: nil)
			return
		}
		let urlStr = "https://post.imageshack.us/upload_api.php"
		let url = URL(string: urlStr)!
		let imageData = UIImageJPEGRepresentation(image, 0.2)!
		let keyData = "2679GJMV25b978622f28e584f5e6e432b7af8e82".data(using: String.Encoding.utf8)!
		let keyJSON = "json".data(using: String.Encoding.utf8)!
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
						let links = responseJSON["links"] as? [String: AnyObject],
						let imgLink = links["image_link"] as? String else {
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
	

	@IBAction func saveAccountChangesButtonPressed(_ sender: UIButton) {
		
		guard let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
			self.present(loginVC, animated: true, completion: nil)
			return
		}
		
		if caloriesPerWeekLabel.text!.isEmpty {  } else {
			userGoals["calorieGoal"] = caloriesPerWeekLabel.text as AnyObject?
		}
		if workoutsPerWeekLabel.text!.isEmpty {  } else {
			userGoals["workoutGoal"] = workoutsPerWeekLabel!.text as AnyObject?
		}
		if myFitnessManifestoTextView.text.isEmpty { } else {
			userGoals["manifesto"] = myFitnessManifestoTextView!.text as AnyObject?
		}
		print(self.userGoals)
		DataSerice.ds.REF_USERS.child(byAppendingPath: uid).updateChildValues(userGoals)
		
		navigationController?.popViewController(animated: true)
		
	}
	
	@IBAction func logOutButtonPRessed(_ sender: AnyObject) {
		UserDefaults.standard.setValue(nil, forKey: KEY_UID)
		let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
		self.present(loginVC, animated: true, completion: nil)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
