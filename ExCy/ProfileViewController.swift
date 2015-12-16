//
//  ProfileViewController.swift
//  ExCy
//
//  Created by Luke Regan on 7/20/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse


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
	
	var workoutsObject: NSMutableArray = NSMutableArray() {
		didSet{
			self.updateView()
			print("Im being called once the workouts object was set")
		}
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if PFUser.currentUser() == nil {
			
		} else {
			usernameLabel.text = PFUser.currentUser()?.username
			
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
			let strDate = dateFormatter.stringFromDate(PFUser.currentUser()!.createdAt!)
			memberSinceLabel.text = "friend since: \(strDate)"
			self.fetchAllObjects()
			self.fetchAllObjectsFromLocalDataStore()
			
			updatePersonalProfile()
		}
    }
	
	//Query
	
	
	func fetchAllObjectsFromLocalDataStore() {
		let query: PFQuery = PFQuery(className: "Workout")
		query.fromLocalDatastore()
		query.whereKey("username", equalTo: (PFUser.currentUser()!.username)!)
		query.addDescendingOrder("createdAt")
		query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
			if (error == nil) {
				let temp: NSArray = objects! as NSArray
				self.workoutsObject = temp.mutableCopy() as! NSMutableArray
			} else {
				print(error!.userInfo)
			}
		}
		
//		let personalQuery: PFQuery = PFQuery(className: "UserGoals")
//		personalQuery.fromLocalDatastore()
//		personalQuery.whereKey("username", equalTo: (PFUser.currentUser()!.username)!)
//		personalQuery.addDescendingOrder("createdAt")
//		personalQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//			if (error == nil) {
//				let temp: NSArray = objects! as NSArray
//				self.goalsObject = temp.mutableCopy() as! NSMutableArray
//			} else {
//				print(error!.userInfo)
//			}
//		}
	}
	
	
	func fetchAllObjects() {
		PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
		let query: PFQuery = PFQuery(className: "Workout")
		query.whereKey("username", equalTo: (PFUser.currentUser()!.username)!)
		query.addDescendingOrder("createdAt")
		query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
			if (error == nil) {
				PFObject.pinAllInBackground(objects, block: nil)
			} else {
				print(error!.userInfo)
			}
		}
		
//		let personalQuery: PFQuery = PFQuery(className: "UserGoals")
//		personalQuery.whereKey("username", equalTo: (PFUser.currentUser()!.username)!)
//		personalQuery.addDescendingOrder("createdAt")
//		personalQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//			if (error == nil) {
//				PFObject.pinAllInBackground(objects, block: nil)
//			} else {
//				print(error!.userInfo)
//			}
//		}
	}
	
	override func viewDidAppear(animated: Bool) {
		updatePersonalProfile()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		
    }
	
	// View updates
	
	func updateView() {
		dispatch_async(dispatch_get_main_queue()) { [unowned self] in
			print("Im being called in update view")
			
			for var index = 0; index < 5; index++ {
				if self.workoutsObject.count > index {
					print("Workouts are greater than 0")
					if let workout = self.workoutsObject.objectAtIndex(index) as? PFObject {
						print("workouts exist")
						self.workoutTitleLabels[index].text = workout["title"] as? String
						self.workoutTimeLabels[index].text = workout["timeWorkedOut"] as? String
						self.workoutDateLabels[index].text = workout["date"] as? String
						if let minTemp = workout["minTemp"] as? Int {
							if let maxTemp = workout["maxTemp"] as? Int {
								self.workoutIntensityLabels[index].text = "min:\(minTemp)\n max:\(maxTemp)"}}
						self.caloriesButnedLabels[index].text = String(workout["caloriesBurned"] as! Int)
						self.enjoymentLabels[index].text = workout["enjoyment"] as? String
						self.workoutLocationLabels[index].text = workout["location"] as? String
						self.enjoymentImageViews[index].image = self.workoutEnjoyment((workout["enjoyment"] as! String))
						self.workoutLocationImages[index].image = self.workoutLocation((workout["location"] as! String))

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
	}
	
	func updatePersonalProfile () {
		let query = PFQuery(className: "UserGoals")
		query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
		query.getFirstObjectInBackgroundWithBlock({ object, error in
			if error == nil {
				if let userImageFile = object!["inspirationalImageOne"] as? PFFile {
					userImageFile.getDataInBackgroundWithBlock {
						(imageData: NSData?, error: NSError?) -> Void in
						if error == nil {
							if let imageData = imageData { self.InspirationImage1.image = UIImage(data: imageData) }
						}
					}
				}
				if let userImageFile = object!["inspirationalImageTwo"] as? PFFile {
					userImageFile.getDataInBackgroundWithBlock {
						(imageData: NSData?, error: NSError?) -> Void in
						if error == nil {
							if let imageData = imageData { self.inspirationImage2.image = UIImage(data: imageData) }
						}
					}
				}
				if let userImageFile = object!["inspirationalImageThree"] as? PFFile {
					userImageFile.getDataInBackgroundWithBlock {
						(imageData: NSData?, error: NSError?) -> Void in
						if error == nil {
							if let imageData = imageData { self.inspirationImage3.image = UIImage(data: imageData) }
						}
					}
				}
				if let profileImage = object!["profileImage"] as? PFFile {
					profileImage.getDataInBackgroundWithBlock {
						(imageData: NSData?, error: NSError?) -> Void in
						if error == nil {
							if let imageData = imageData { self.profileImage.image = UIImage(data: imageData) }
						}
					}
				}
				if let calorieGoal = object!["calorieGoal"] as? String {
					self.caloriesGoalLabel.text = calorieGoal
				}
				if let workoutGoal = object!["workoutGoal"] as? String {
					self.workoutsGoalLabel.text = workoutGoal
				}
				if let manifesto = object!["manifesto"] as? String {
					self.fitnessManifestoLabel.text = manifesto
				}
			} else {
				
			}
		})
	}
	
	
	@IBAction func recentHistoryUpdate(sender: UIButton) {
		updateView()
		updatePersonalProfile()
	}
	
	@IBAction func changeImageButtonPressed(sender: AnyObject) {
		let image = UIImagePickerController()
		image.delegate = self
		image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		image.allowsEditing = false
		self.presentViewController(image, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		self.dismissViewControllerAnimated(true, completion: nil)
		//let blueColor = UIColor(red: 50/255, green: 145/255, blue: 210/255, alpha: 1.0)
		//let croppedImage = Toucan(image: image).maskWithRoundedRect(cornerRadius: 50.0, borderWidth: 15.0, borderColor: blueColor).image
		profileImage.image = image
		let imageData = UIImageJPEGRepresentation(image, 0.6)
		let parseImage = PFFile(name: "profileImage", data: imageData!)
		let userGoals = PFObject(className: "UserGoals")
		userGoals["profileImage"] = parseImage
		userGoals["username"] = PFUser.currentUser()!.username
		userGoals.saveInBackground()
		
	}
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
