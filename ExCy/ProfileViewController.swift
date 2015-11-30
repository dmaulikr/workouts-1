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
	@IBOutlet var changeImageButton: UIButton!
	
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
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
				self.fetchAllObjects()
				self.fetchAllObjectsFromLocalDataStore()
			}
		}
		
		
    }
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
	}
	
	override func viewDidAppear(animated: Bool) {
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		
    }
	
	func updateView() {
		dispatch_async(dispatch_get_main_queue()) { [unowned self] in
			print("Im being called in update view")
			let defaults = NSUserDefaults.standardUserDefaults()
			if let savedImage: AnyObject = defaults.valueForKey("profileImage"){
				let recoveredImage = UIImage(data: savedImage as! NSData)
				self.profileImage.image = recoveredImage //croppedImage
				self.changeImageButton.hidden = true
			}
			if let caloriesGoal: AnyObject = defaults.valueForKey("CaloriesPerWeek"){
				self.caloriesGoalLabel.text = (caloriesGoal as! String)
			}
			if let workoutsGoal: AnyObject = defaults.valueForKey("WorkoutsPerWeek"){
				self.workoutsGoalLabel.text = (workoutsGoal as! String)
			}
			if let fitnessManifesto: AnyObject = defaults.valueForKey("FitnessManifesto"){
				self.fitnessManifestoLabel.text = (fitnessManifesto as! String)
			}
			
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
			
			if let inspirationalImage1: AnyObject = defaults.valueForKey("InspirationImage1"){
				let recoveredImage = UIImage(data: inspirationalImage1 as! NSData)
				self.InspirationImage1.image = recoveredImage //croppedImage
			}
			if let inspirationalImage2: AnyObject = defaults.valueForKey("InspirationImage2"){
				let recoveredImage = UIImage(data: inspirationalImage2 as! NSData)
				self.inspirationImage2.image = recoveredImage //croppedImage
			}
			if let inspirationalImage3: AnyObject = defaults.valueForKey("InspirationImage3"){
				let recoveredImage = UIImage(data: inspirationalImage3 as! NSData)
				self.inspirationImage3.image = recoveredImage //croppedImage
			}

		}
	}
	
	
	@IBAction func recentHistoryUpdate(sender: UIButton) {
		updateView()
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
		NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "profileImage")
		
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
