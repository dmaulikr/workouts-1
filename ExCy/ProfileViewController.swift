//
//  ProfileViewController.swift
//  ExCy
//
//  Created by Luke Regan on 7/20/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

	

	@IBOutlet var profileImage: UIImageView!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var caloriesGoalLabel: UILabel!
	@IBOutlet var workoutsGoalLabel: UILabel!
	@IBOutlet var fitnessManifestoLabel: UILabel!
	@IBOutlet var memberSinceLabel: UILabel!
	
	@IBOutlet var InspirationImage1: UIImageView!
	@IBOutlet var inspirationImage2: UIImageView!
	@IBOutlet var inspirationImage3: UIImageView!
	
	@IBOutlet var workoutTitleLabels: [UILabel]!
	@IBOutlet var workoutDateLabels: [UILabel]!
	@IBOutlet var workoutTimeLabels: [UILabel]!
	@IBOutlet var workoutIntensityLabels: [UILabel]!
	@IBOutlet var caloriesButnedLabels: [UILabel]!
	@IBOutlet var enjoymentLabels: [UILabel]!
	@IBOutlet var enjoymentImageViews: [UIImageView]!
	@IBOutlet var workoutLocationLabels: [UILabel]!
	@IBOutlet var workoutLocationImages: [UIImageView]!
	
	var workoutsObject = [Workout]()
	var userDict = [String: AnyObject]()
	
	static var imageCache = NSCache()
	var request: Request?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		guard let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn")
			self.presentViewController(loginVC, animated: true, completion: nil)
			return
		}
		
		
		queryFirebaseWorkouts()
		
		DataSerice.ds.REF_USERS.childByAppendingPath(uid).observeEventType(.Value, withBlock: { snapshot in
			if let snapshot = snapshot.value as? [String: AnyObject] {
				self.userDict = snapshot
				print(self.userDict)
			}
			self.updatePersonalProfile()
		})
    }
	
	override func viewDidAppear(animated: Bool) {
		guard let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn")
			self.presentViewController(loginVC, animated: true, completion: nil)
			return
		}
		
		
		queryFirebaseWorkouts()
		
		DataSerice.ds.REF_USERS.childByAppendingPath(uid).observeEventType(.Value, withBlock: { snapshot in
			if let snapshot = snapshot.value as? [String: AnyObject] {
				self.userDict = snapshot
				print(self.userDict)
			}
			self.updatePersonalProfile()
		})
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		
    }
	
	func queryFirebaseWorkouts() {
		
		guard let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn")
			self.presentViewController(loginVC, animated: true, completion: nil)
			return
		}

		DataSerice.ds.REF_WORKOUTS.childByAppendingPath(uid).queryLimitedToLast(5).observeEventType(.Value, withBlock: { snapshot in
			if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
				for snap in snapshots {
					if let workoutDict = snap.value as? [String: AnyObject] {
						let workout = Workout(dictionary: workoutDict)
						self.workoutsObject.insert(workout, atIndex: 0)
						
					}
				}
			}
			self.updateView()
		})
	}
	
	func updatePersonalProfile() {
		
		if let username = userDict["username"] as? String { usernameLabel.text = username }
		if let memberSince = userDict["memberSince"] as? String { memberSinceLabel.text = memberSince }
		if let caloriesGoal = userDict["calorieGoal"] as? String { caloriesGoalLabel.text = caloriesGoal }
		if let workoutsGoal = userDict["workoutGoal"] as? String { workoutsGoalLabel.text = workoutsGoal }
		if let fitnessManifesto = userDict["manifesto"] as? String {  fitnessManifestoLabel.text = fitnessManifesto}
		
		if let profileUrl = userDict["profileImageUrl"] as? String {
			if let profile = ProfileViewController.imageCache.objectForKey(profileUrl) as? UIImage {
				self.profileImage.image = profile
			} else {
				request = Alamofire.request(.GET, profileUrl).validate(contentType: ["image/*"]).response { request, response, data, error in
					if error == nil {
						let image = UIImage(data: data!)!
						self.profileImage.image = image
						ProfileViewController.imageCache.setObject(image, forKey: profileUrl)
					}
				}
			}
		}
		if let inspiringImageUrl1 = userDict["inspiringImage1"] as? String {
			if let inspiration = ProfileViewController.imageCache.objectForKey(inspiringImageUrl1) as? UIImage {
				self.InspirationImage1.image = inspiration
			} else {
				request = Alamofire.request(.GET, inspiringImageUrl1).validate(contentType: ["image/*"]).response { request, response, data, error in
					if error == nil {
						let image = UIImage(data: data!)!
						self.InspirationImage1.image = image
						ProfileViewController.imageCache.setObject(image, forKey: inspiringImageUrl1)
					}
				}
			}
		}
		if let inspiringImageUrl2 = userDict["inspiringImage2"] as? String {
			if let inspiration = ProfileViewController.imageCache.objectForKey(inspiringImageUrl2) as? UIImage {
				self.inspirationImage2.image = inspiration
			} else {
				request = Alamofire.request(.GET, inspiringImageUrl2).validate(contentType: ["image/*"]).response { request, response, data, error in
					if error == nil {
						let image = UIImage(data: data!)!
						self.inspirationImage2.image = image
						ProfileViewController.imageCache.setObject(image, forKey: inspiringImageUrl2)
					}
				}
			}
		}
		if let inspiringImageUrl3 = userDict["inspiringImage3"] as? String {
			if let inspiration = ProfileViewController.imageCache.objectForKey(inspiringImageUrl3) as? UIImage {
				self.inspirationImage3.image = inspiration
			} else {
				request = Alamofire.request(.GET, inspiringImageUrl3).validate(contentType: ["image/*"]).response { request, response, data, error in
					if error == nil {
						let image = UIImage(data: data!)!
						self.inspirationImage3.image = image
						ProfileViewController.imageCache.setObject(image, forKey: inspiringImageUrl3)
					}
				}
			}
		}
	}
	
	// View updates
	
	func updateView() {
		dispatch_async(dispatch_get_main_queue()) { [unowned self] in
			print("Im being called in update view")
			
			for var index = 0; index < 5; index++ {
				if self.workoutsObject.count > index {
					print("Workouts are greater than 0")
					let workout = self.workoutsObject[index]
					self.workoutTitleLabels[index].text = workout.workoutTitle
					self.workoutTimeLabels[index].text = workout.timeAsString
					self.workoutDateLabels[index].text = workout.dateCompleted
					self.workoutIntensityLabels[index].text = "min:\(workout.minTemp)\n max:\(workout.maxTemp)"
					self.caloriesButnedLabels[index].text = "\(workout.caloriesBurned)"
					self.enjoymentLabels[index].text = workout.enjoyment
					self.workoutLocationLabels[index].text = workout.location
					self.enjoymentImageViews[index].image = self.workoutEnjoyment(workout.enjoyment)
					self.workoutLocationImages[index].image = self.workoutLocation(workout.location)
				} else {
					self.workoutTitleLabels[index].text = "---"
					self.workoutTimeLabels[index].text = "---"
					self.workoutDateLabels[index].text = "---"
					self.workoutIntensityLabels[index].text = "---"
					self.caloriesButnedLabels[index].text = "---"
					self.enjoymentLabels[index].text = "---"
					self.workoutLocationLabels[index].text = "---"
					self.enjoymentImageViews[index].image = self.workoutEnjoyment("enjoyment")
					self.workoutLocationImages[index].image = self.workoutLocation("location")

				}
			}
		}
	}
	

	
	
	@IBAction func recentHistoryUpdate(sender: UIButton) {
		updateView()
		//updatePersonalProfile()
	}
	
//	@IBAction func changeImageButtonPressed(sender: AnyObject) {
//		let image = UIImagePickerController()
//		image.delegate = self
//		image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//		image.allowsEditing = false
//		self.presentViewController(image, animated: true, completion: nil)
//	}
//	
//	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//		self.dismissViewControllerAnimated(true, completion: nil)
//		profileImage.image = image
//		
//		let urlStr = "https://post.imageshack.us/upload_api.php"
//		let url = NSURL(string: urlStr)!
//		let imageData = UIImageJPEGRepresentation(image, 0.4)
//		let keyData = "2679GJMV25b978622f28e584f5e6e432b7af8e82".dataUsingEncoding(NSUTF8StringEncoding)
//		let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)
//		Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
//			multipartFormData.appendBodyPart(data: imageData!, name: "fileUpload", mimeType: "image/jpg")
//			multipartFormData.appendBodyPart(data: keyData!, name: "key")
//			multipartFormData.appendBodyPart(data: keyJSON!, name: "format")
//		}) { encodingResult in
//			switch encodingResult {
//			case .Success(let upload, _, _) :
//				upload.responseJSON{ response in
//					if let info = response.result.value as? [String: AnyObject] {
//						if let links = info["links"] as? [String: AnyObject] {
//							if let imgLink = links["image_link"] as? String {
//								print("LINK: \(imgLink)")
//							}
//						}
//					}
//				}
//			case .Failure(let error):
//				print(error)
//			}
//		}
//		//DataSerice.ds.REF_USERS.childByAppendingPath(uid).updateChildValues( blahblabhblahb )
//		
//	}
	func workoutEnjoyment(enjoyment: String) -> UIImage {
		switch enjoyment {
		case "awful": return UIImage(named: "SmilieIcons_sad.png")!
		case "bad": return UIImage(named: "SmilieIcons_sad.png")!
		case "good": return UIImage(named: "SmilieIcons_satisfied.png")!
		case "great": return UIImage(named: "SmilieIcons_happy.png")!
		case "amazing": return UIImage(named: "SmilieIcons_happy.png")!
		default: return UIImage(named: "SmilieIcons_happy.png")!
		}
	}
	func workoutLocation(location: String) -> UIImage {
		switch location {
		case "at home": return UIImage(named: "Account_Home.png")!
		case "at work": return UIImage(named: "Account_Work.png")!
		case "traveling": return UIImage(named: "Account_Traveling.png")!
		case "on the go": return UIImage(named: "Account_Onthego.png")!
		default: return UIImage(named: "Account_Home.png")!
		}
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
