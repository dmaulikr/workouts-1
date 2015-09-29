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
	
	@IBOutlet var workoutTitle1: UILabel!
	@IBOutlet var workoutDate1: UILabel!
	@IBOutlet var workoutTime1: UILabel!
	@IBOutlet weak var caloriesBurnedLabel1: UILabel!
	@IBOutlet weak var enjoymentImageView1: UIImageView!
	@IBOutlet weak var enjoymentLabel1: UILabel!
	@IBOutlet weak var locationImageView1: UIImageView!
	@IBOutlet weak var locationLabel1: UILabel!
	
	@IBOutlet var workoutTitle2: UILabel!
	@IBOutlet var workoutDate2: UILabel!
	@IBOutlet var workoutTime2: UILabel!
	@IBOutlet weak var caloriesBurnedLabel2: UILabel!
	@IBOutlet weak var enjoymentImageView2: UIImageView!
	@IBOutlet weak var enjoymentLabel2: UILabel!
	@IBOutlet weak var locationImageView2: UIImageView!
	@IBOutlet weak var locationLabel2: UILabel!
	
	@IBOutlet var workoutTitle3: UILabel!
	@IBOutlet var workoutDate3: UILabel!
	@IBOutlet var workoutTime3: UILabel!
	@IBOutlet weak var caloriesBurnedLabel3: UILabel!
	@IBOutlet weak var enjoymentImageView3: UIImageView!
	@IBOutlet weak var enjoymentLabel3: UILabel!
	@IBOutlet weak var locationImageView3: UIImageView!
	@IBOutlet weak var locationLabel3: UILabel!
	
	@IBOutlet var workoutTitle4: UILabel!
	@IBOutlet var workoutDate4: UILabel!
	@IBOutlet var workoutTime4: UILabel!
	@IBOutlet weak var caloriesBurnedLabel4: UILabel!
	@IBOutlet weak var enjoymentImageView4: UIImageView!
	@IBOutlet weak var enjoymentLabel4: UILabel!
	@IBOutlet weak var locationImageView4: UIImageView!
	@IBOutlet weak var locationLabel4: UILabel!
	
	@IBOutlet var workoutTitle5: UILabel!
	@IBOutlet var workoutDate5: UILabel!
	@IBOutlet var workoutTime5: UILabel!
	@IBOutlet weak var caloriesBurnedLabel5: UILabel!
	@IBOutlet weak var enjoymentImageView5: UIImageView!
	@IBOutlet weak var enjoymentLabel5: UILabel!
	@IBOutlet weak var locationImageView5: UIImageView!
	@IBOutlet weak var locationLabel5: UILabel!
	
	var workoutsObject: NSMutableArray! = NSMutableArray()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if PFUser.currentUser() == nil {
			
		} else {
			updateView()
			usernameLabel.text = PFUser.currentUser()?.username
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
			let strDate = dateFormatter.stringFromDate(PFUser.currentUser()!.createdAt!)
			memberSinceLabel.text = "friend since: \(strDate)"
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
				//self.fetchAllObjectsFromLocalDataStore()
			} else {
				print(error!.userInfo)
			}
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		// Do any additional setup after loading the view.
		updateView()
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	
	
	func updateView() {
		self.fetchAllObjectsFromLocalDataStore()
		self.fetchAllObjects()
		let defaults = NSUserDefaults.standardUserDefaults()
		if let savedImage: AnyObject = defaults.valueForKey("profileImage"){
			let recoveredImage = UIImage(data: savedImage as! NSData)
			profileImage.image = recoveredImage //croppedImage
			changeImageButton.hidden = true
		}
		if let caloriesGoal: AnyObject = defaults.valueForKey("CaloriesPerWeek"){
			caloriesGoalLabel.text = (caloriesGoal as! String)
		}
		if let workoutsGoal: AnyObject = defaults.valueForKey("WorkoutsPerWeek"){
			workoutsGoalLabel.text = (workoutsGoal as! String)
		}
		if let fitnessManifesto: AnyObject = defaults.valueForKey("FitnessManifesto"){
			fitnessManifestoLabel.text = (fitnessManifesto as! String)
		}
		
		if workoutsObject.count > 0 {
			//start of 1
			workoutTitle1.text = workoutsObject[0]["title"] as? String
			workoutTime1.text = workoutsObject[0]["timeWorkedOut"] as? String
			workoutDate1.text = workoutsObject[0]["date"] as? String
			caloriesBurnedLabel1.text = String(workoutsObject[0]["caloriesBurned"] as! Double)
			enjoymentLabel1.text = workoutsObject[0]["enjoyment"] as? String
			locationLabel1.text = workoutsObject[0]["location"] as? String
			enjoymentImageView1.image = workoutEnjoyment((workoutsObject[0]["enjoyment"] as? String)!)
			locationImageView1.image = workoutLocation((workoutsObject[0]["location"] as? String)!)
				if workoutsObject.count > 1 {
					//start of 2
					workoutTitle2.text = workoutsObject[1]["title"] as? String
					workoutTime2.text = workoutsObject[1]["timeWorkedOut"] as? String
					workoutDate2.text = workoutsObject[1]["date"] as? String
					caloriesBurnedLabel2.text = String(workoutsObject[1]["caloriesBurned"] as! Double)
					enjoymentLabel2.text = workoutsObject[1]["enjoyment"] as? String
					locationLabel2.text = workoutsObject[1]["location"] as? String
					enjoymentImageView2.image = workoutEnjoyment((workoutsObject[1]["enjoyment"] as? String)!)
					locationImageView2.image = workoutLocation((workoutsObject[1]["location"] as? String)!)
					if workoutsObject.count > 2 {
						//start of 3
						workoutTitle3.text = workoutsObject[2]["title"] as? String
						workoutTime3.text = workoutsObject[2]["timeWorkedOut"] as? String
						workoutDate3.text = workoutsObject[2]["date"] as? String
						caloriesBurnedLabel3.text = String(workoutsObject[2]["caloriesBurned"] as! Double)
						enjoymentLabel3.text = workoutsObject[2]["enjoyment"] as? String
						locationLabel3.text = workoutsObject[2]["location"] as? String
						enjoymentImageView3.image = workoutEnjoyment((workoutsObject[2]["enjoyment"] as? String)!)
						locationImageView3.image = workoutLocation((workoutsObject[2]["location"] as? String)!)
						if workoutsObject.count > 3 {
							// start of 4
							workoutTitle4.text = workoutsObject[3]["title"] as? String
							workoutTime4.text = workoutsObject[3]["timeWorkedOut"] as? String
							workoutDate4.text = workoutsObject[3]["date"] as? String
							caloriesBurnedLabel4.text = String(workoutsObject[3]["caloriesBurned"] as! Double)
							enjoymentLabel4.text = workoutsObject[3]["enjoyment"] as? String
							locationLabel4.text = workoutsObject[3]["location"] as? String
							enjoymentImageView4.image = workoutEnjoyment((workoutsObject[3]["enjoyment"] as? String)!)
							locationImageView4.image = workoutLocation((workoutsObject[3]["location"] as? String)!)
							if workoutsObject.count > 4 {
								//start of 5
								workoutTitle5.text = workoutsObject[4]["title"] as? String
								workoutTime5.text = workoutsObject[4]["timeWorkedOut"] as? String
								workoutDate5.text = workoutsObject[4]["date"] as? String
								caloriesBurnedLabel5.text = String(workoutsObject[4]["caloriesBurned"] as! Double)
								enjoymentLabel5.text = workoutsObject[4]["enjoyment"] as? String
								locationLabel5.text = workoutsObject[4]["location"] as? String
								enjoymentImageView5.image = workoutEnjoyment((workoutsObject[4]["enjoyment"] as? String)!)
								locationImageView5.image = workoutLocation((workoutsObject[4]["location"] as? String)!)
							}
						}
					}
				}
			}
		

		if let inspirationalImage1: AnyObject = defaults.valueForKey("InspirationImage1"){
			let recoveredImage = UIImage(data: inspirationalImage1 as! NSData)
			InspirationImage1.image = recoveredImage //croppedImage
		}
		if let inspirationalImage2: AnyObject = defaults.valueForKey("InspirationImage2"){
			let recoveredImage = UIImage(data: inspirationalImage2 as! NSData)
			inspirationImage2.image = recoveredImage //croppedImage
		}
		if let inspirationalImage3: AnyObject = defaults.valueForKey("InspirationImage3"){
			let recoveredImage = UIImage(data: inspirationalImage3 as! NSData)
			inspirationImage3.image = recoveredImage //croppedImage
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
		case "at home": return UIImage(named: "Account_Home.png")!
		case "at work": return UIImage(named: "Account_Work.png")!
		case "traveling": return UIImage(named: "Account_Traveling.png")!
		case "on the go": return UIImage(named: "Account_Work.png")!
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
