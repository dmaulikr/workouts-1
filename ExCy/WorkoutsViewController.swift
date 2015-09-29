//
//  WorkoutsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 2/16/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse

class WorkoutsViewController: UIViewController {
	
	var workoutNumber: Int?
	var workoutTime: Int?
	@IBOutlet weak var workoutButton: UIButton!

	@IBOutlet var zoneImageView: UIImageView!
	@IBOutlet weak var progressView: WorkoutProgressView!
	@IBOutlet var stopwatchLabel: UILabel!
	@IBOutlet weak var currentZoneImageView: UIImageView!
	@IBOutlet weak var targetZoneImageView: UIImageView!
	
	var timer: NSTimer?
	var progressCounter = 0
	var initialTime: Float = 1
	
	//Local Save
	var object: PFObject!
	var willCompleteSurvey = false
	var workoutName = "Arm Candy"
	
	var zoneBrain: ZoneBrain?
	var zoneIncrementTime = 0
	var zoneArray: [Int]?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	
	override func viewWillAppear(animated: Bool) {
		if let newNumber = workoutNumber {
			switch newNumber {
			case 1: workoutTime = 420
				workoutName = "Arm Candy"
				zoneBrain = ZoneBrain.init(time: 420, zones: 7)
				zoneArray = zoneBrain!.getZoneArray()
			case 2: workoutTime = 1380
				workoutName = "Super Cycle Cardio"
				zoneBrain = ZoneBrain.init(time: 1380, zones: 23)
				zoneArray = zoneBrain!.getZoneArray()
			case 3: workoutTime = 900
				workoutName = "Cycle Leg Blast"
				zoneBrain = ZoneBrain.init(time: 900, zones: 7)
				zoneArray = zoneBrain!.getZoneArray()
			case 4: workoutTime = 600
				workoutName = "Core Floor Explosion"
				zoneBrain = ZoneBrain.init(time: 600, zones: 10)
				zoneArray = zoneBrain!.getZoneArray()
			case 5: workoutTime = 600
				workoutName = "Arm Blast"
				zoneBrain = ZoneBrain.init(time: 600, zones: 7)
				zoneArray = zoneBrain!.getZoneArray()
			case 6: workoutTime = 420
				workoutName = "Ultimate Arm & Leg Toning"
				zoneBrain = ZoneBrain.init(time: 420, zones: 7)
				zoneArray = zoneBrain!.getZoneArray()
			default: workoutTime = 420
				workoutName = "Arm Candy"
				zoneBrain = ZoneBrain.init(time: 420, zones: 7)
				zoneArray = zoneBrain!.getZoneArray()
			}
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.targetZoneImageView.image = UIImage(named: "ZoneIntensity\(zoneArray!.first!).png")
		self.initialTime = Float(workoutTime!)
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateUI"), userInfo: nil, repeats: true)
		
	}
	
	override func viewWillLayoutSubviews() {
		if let newNumber = workoutNumber {
			switch newNumber {
			case 1: zoneImageView.image = UIImage(named: "Arm candy live graph.png")
				workoutButton.imageView?.image = UIImage(named: "WBArmCandy.png")
			case 2: zoneImageView.image = UIImage(named: "SuperCycleGraphNew.png")
				workoutButton.imageView?.image = UIImage(named: "WBSuperCycleCardio.png")
			case 3: zoneImageView.image = UIImage(named: "Cycle leg blast live graph.png")
				workoutButton.imageView?.image = UIImage(named: "WBCycleLegBlast.png")
			case 4: zoneImageView.image = UIImage(named: "Core floor summary graph.png")
				workoutButton.imageView?.image = UIImage(named: "WBCoreFloorExplosion.png")
			case 5: zoneImageView.image = UIImage(named: "Arm blast graph.png")
				workoutButton.imageView?.image = UIImage(named: "WBArmBlast.png")
			case 6: zoneImageView.image = UIImage(named: "Arm and leg graph summary.png")
				workoutButton.imageView?.image = UIImage(named: "WBUltimateArmLegTone.png")
			default: zoneImageView.image = UIImage(named: "Arm candy live graph.png")
				workoutButton.imageView?.image = UIImage(named: "WBArmCandy.png")
			}
		}
	}
	
	
	func setUpZoneView() {
		if zoneBrain == nil { return }
		zoneIncrementTime++
		if zoneIncrementTime >= zoneBrain!.zoneChangeInSeconds {
			zoneIncrementTime = 0
			zoneArray?.removeFirst()
			if zoneArray?.count > 0 {
				self.targetZoneImageView.image = UIImage(named: "ZoneIntensity\(zoneArray!.first!).png")
			}
			
		}
	}
	
	// Parse Query
	func saveWorkout() {
		self.object = PFObject(className: "Workout")
		let seconds = Int(self.initialTime) - workoutTime!
		self.object["username"] = PFUser.currentUser()!.username
		self.object["title"] = workoutName
		self.object["timeWorkedOut"] = stringConversion(seconds)
		self.object["caloriesBurned"] = (Double(seconds) / 60) * 17
		let date = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE hh:mm a"
		self.object["date"] = dateFormatter.stringFromDate(date)
		
		
		if willCompleteSurvey == true {
			self.performSegueWithIdentifier("surveyFromWorkout", sender: self)
		} else {
			self.object["enjoyment"] = "default"
			self.object["location"] = "default"
			self.object.saveEventually { (success, error) -> Void in
				if (error == nil){
					
				} else {
					print(error!.userInfo)
				}
			}
		}
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "surveyFromWorkout" {
			let surveyVC: SurveyViewController = segue.destinationViewController as! SurveyViewController
			let object: PFObject = self.object as PFObject
			surveyVC.object = object
		}
	}

	
	
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	
	func stringConversion (seconds:Int) -> String {
		let minutesCount = seconds / 60
		let secondsCount = seconds - (minutesCount * 60)
		var minuteString = String(minutesCount)
		var secondString = String(secondsCount)
		if secondsCount < 10 { secondString = "0\(secondsCount)"}
		else { secondString = "\(secondsCount)" }
		if minutesCount < 10 { minuteString = "0\(minutesCount)"}
		else { minuteString = "\(minutesCount)" }
		return "\(minuteString):\(secondString)"
	}
	
	
	func updateUI() {
		if (workoutTime != nil) && workoutTime > 0 {
			workoutTime!--
			self.stopwatchLabel.text = stringConversion(workoutTime!)
			self.progressCounter++
			
			self.progressView.progress = CGFloat(progressCounter) / CGFloat(initialTime)
			self.progressView.setNeedsDisplay()
			self.setUpZoneView()
			
		} else if (workoutTime != nil) && workoutTime == 0 {
			self.timer?.invalidate()
			self.timer = nil
			stopAlert()
		} else {
			self.timer?.invalidate()
			self.timer = nil
			stopAlert()
		}
	}
	
	
	func setTimer(){
		if (self.timer != nil) {
			self.timer?.invalidate()
			self.timer = nil
		} else {
			self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateUI", userInfo: nil, repeats: true)
		}
	}
	
	@IBAction func startButtonPressed(sender: UIButton)
	{
		self.setTimer()
	}
	@IBAction func pauseButtonPressed(sender: UIButton)
	{
		self.setTimer()
		pauseAlert()
	}
	@IBAction func stopButtomPressed(sender: UIButton)
	{
		self.setTimer()
		stopAlert()
	}
	
	
//Workout Alerts
	
	func getTitleOfWorkout() -> String {
		if let newNumber = workoutNumber {
			switch newNumber {
				case 1: return "Arm Candy"
				case 2: return "Super Cycle Cardio"
				case 3: return "Cycle Leg Blast"
				case 4: return "Core Floor Explosion"
				case 5: return "Arm Blast"
				case 6: return "Ultimate Arm and Leg Toning"
				default: return "Super Cycle Cardio"
			}
		}
		return "default"
	}
	
	
	
	func pauseAlert () {
		let alertController = UIAlertController(title: "Continue?", message: "healthy is... finishing strong!", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "exit", style: .Destructive) { action in
			self.setTimer()
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "resume", style: .Cancel) { action in
			self.setTimer()
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func stopAlert () {
		let alertController = UIAlertController(title: "Workout Complete", message: "", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "save", style: .Default) { action in
			self.surveyAlert()
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "trash and exit", style: .Destructive) { action in
			self.setTimer()
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(cancelAction)
		let continueAction = UIAlertAction(title: "Resume Workout", style: .Cancel) { action in
			self.setTimer()
		}
		alertController.addAction(continueAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func surveyAlert () {
		let alertController = UIAlertController(title: "Complete Survey?", message: "Please take a moment to complete a quick four question survey", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "yes", style: .Default) { action in
			self.willCompleteSurvey = true
			self.saveWorkout()
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "no thanks", style: .Cancel) { action in
			self.willCompleteSurvey = false
			self.saveWorkout()
			self.setTimer()
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	
	

}
