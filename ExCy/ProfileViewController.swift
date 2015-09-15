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
	
	@IBOutlet var workoutTitle2: UILabel!
	@IBOutlet var workoutDate2: UILabel!
	@IBOutlet var workoutTime2: UILabel!
	
	@IBOutlet var workoutTitle3: UILabel!
	@IBOutlet var workoutDate3: UILabel!
	@IBOutlet var workoutTime3: UILabel!
	
	@IBOutlet var workoutTitle4: UILabel!
	@IBOutlet var workoutDate4: UILabel!
	@IBOutlet var workoutTime4: UILabel!
	
	@IBOutlet var workoutTitle5: UILabel!
	@IBOutlet var workoutDate5: UILabel!
	@IBOutlet var workoutTime5: UILabel!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		updateView()
		usernameLabel.text = PFUser.currentUser()?.username
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
		let strDate = dateFormatter.stringFromDate(PFUser.currentUser()!.createdAt!)
		memberSinceLabel.text = "friend since: \(strDate)"
		
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
		let defaults = NSUserDefaults.standardUserDefaults()
		if let savedImage: AnyObject = defaults.valueForKey("profileImage"){
			let recoveredImage = UIImage(data: savedImage as! NSData)
			//let blueColor = UIColor(red: 50/255, green: 145/255, blue: 210/255, alpha: 1.0)
			//let croppedImage = Toucan(image: recoveredImage!).maskWithRoundedRect(cornerRadius: 50.0, borderWidth: 15.0, borderColor: blueColor).image
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
		if let savedWorkouts = defaults.objectForKey("workouts") as? NSData {
			workouts = NSKeyedUnarchiver.unarchiveObjectWithData(savedWorkouts) as! [Workouts]
			if workouts.count >= 5 {
				workoutTitle5.text = workouts[4].workoutTitle
				workoutTime5.text = workouts[4].totalTime
				workoutDate5.text = workouts[4].dateCompleted
				workoutTitle4.text = workouts[3].workoutTitle
				workoutTime4.text = workouts[3].totalTime
				workoutDate4.text = workouts[3].dateCompleted
				workoutTitle3.text = workouts[2].workoutTitle
				workoutTime3.text = workouts[2].totalTime
				workoutDate3.text = workouts[2].dateCompleted
				workoutTitle2.text = workouts[1].workoutTitle
				workoutTime2.text = workouts[1].totalTime
				workoutDate2.text = workouts[1].dateCompleted
				workoutTitle1.text = workouts[0].workoutTitle
				workoutTime1.text = String(workouts[0].totalTime)
				workoutDate1.text = workouts[0].dateCompleted
			} else if workouts.count >= 4 {
				workoutTitle4.text = workouts[3].workoutTitle
				workoutTime4.text = workouts[3].totalTime
				workoutDate4.text = workouts[3].dateCompleted
				workoutTitle3.text = workouts[2].workoutTitle
				workoutTime3.text = workouts[2].totalTime
				workoutDate3.text = workouts[2].dateCompleted
				workoutTitle2.text = workouts[1].workoutTitle
				workoutTime2.text = workouts[1].totalTime
				workoutDate2.text = workouts[1].dateCompleted
				workoutTitle1.text = workouts[0].workoutTitle
				workoutTime1.text = String(workouts[0].totalTime)
				workoutDate1.text = workouts[0].dateCompleted
			} else if workouts.count >= 3 {
				workoutTitle3.text = workouts[2].workoutTitle
				workoutTime3.text = workouts[2].totalTime
				workoutDate3.text = workouts[2].dateCompleted
				workoutTitle2.text = workouts[1].workoutTitle
				workoutTime2.text = workouts[1].totalTime
				workoutDate2.text = workouts[1].dateCompleted
				workoutTitle1.text = workouts[0].workoutTitle
				workoutTime1.text = String(workouts[0].totalTime)
				workoutDate1.text = workouts[0].dateCompleted
			} else if workouts.count >= 2 {
				workoutTitle2.text = workouts[1].workoutTitle
				workoutTime2.text = workouts[1].totalTime
				workoutDate2.text = workouts[1].dateCompleted
				workoutTitle1.text = workouts[0].workoutTitle
				workoutTime1.text = workouts[0].totalTime
				workoutDate1.text = workouts[0].dateCompleted
			} else if workouts.count >= 1 {
				workoutTitle1.text = workouts[0].workoutTitle
				workoutTime1.text = workouts[0].totalTime
				workoutDate1.text = workouts[0].dateCompleted
			} else {
				
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
	
	
	
	@IBAction func changeImageButtonPressed(sender: AnyObject) {
		var image = UIImagePickerController()
		image.delegate = self
		image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		image.allowsEditing = false
		self.presentViewController(image, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		self.dismissViewControllerAnimated(true, completion: nil)
		let blueColor = UIColor(red: 50/255, green: 145/255, blue: 210/255, alpha: 1.0)
		let croppedImage = Toucan(image: image).maskWithRoundedRect(cornerRadius: 50.0, borderWidth: 15.0, borderColor: blueColor).image
		profileImage.image = croppedImage
		var imageData = UIImageJPEGRepresentation(croppedImage, 0.6)
		NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "profileImage")
		
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
