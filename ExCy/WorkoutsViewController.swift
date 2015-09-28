//
//  WorkoutsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 2/16/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

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
	var progressCounter = 1
	var initialTime: Float = 1
	
	var secondsTilZoneChange: Int?
	var zoneBrain: ZoneBrain?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		if let newNumber = workoutNumber {
			switch newNumber {
			case 1: workoutTime = 420
				zoneBrain = ZoneBrain.init(time: 420, zones: 7)
			case 2: workoutTime = 1380
				zoneBrain = ZoneBrain.init(time: 1380, zones: 23)
			case 3: workoutTime = 900
				zoneBrain = ZoneBrain.init(time: 900, zones: 7)
			case 4: workoutTime = 600
				zoneBrain = ZoneBrain.init(time: 600, zones: 10)
			case 5: workoutTime = 600
				zoneBrain = ZoneBrain.init(time: 600, zones: 7)
			case 6: workoutTime = 420
				zoneBrain = ZoneBrain.init(time: 420, zones: 7)
			default: workoutTime = 420
				zoneBrain = ZoneBrain.init(time: 420, zones: 7)
			}
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.initialTime = Float(workoutTime!)
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateUI"), userInfo: nil, repeats: true)
		
		let defaults = NSUserDefaults.standardUserDefaults()
		if let savedWorkouts = defaults.objectForKey("workouts") as? NSData {
			workouts = NSKeyedUnarchiver.unarchiveObjectWithData(savedWorkouts) as! [Workouts]
		}
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
	
	func setUpView() {
		
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
	
	func saveWorkout() {
		let seconds = Int(self.initialTime) - workoutTime!
		let totalTimeWorkedOut = stringConversion(seconds)
		let title = self.getTitleOfWorkout()
		let workout = Workouts(workoutTitle: title, time: totalTimeWorkedOut)
		workouts.insert(workout, atIndex: 0)
		let savedData = NSKeyedArchiver.archivedDataWithRootObject(workouts)
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setObject(savedData, forKey: "workouts")
	}
	
	
	func pauseAlert () {
		let alertController = UIAlertController(title: "Continue?", message: "healthy is... finishing strong!", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "exit workout", style: .Default) { action in
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "resume", style: .Default) { action in
			self.setTimer()
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func stopAlert () {
		let alertController = UIAlertController(title: "Workout Complete", message: "", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "Save", style: .Default) { action in
			self.surveyAlert()
			self.saveWorkout()
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "trash", style: .Default) { action in
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func surveyAlert () {
		let alertController = UIAlertController(title: "Complete Survey?", message: "Please take a moment to complete a quick four question survey", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "yes", style: .Default) { action in
			let surveyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PostWorkoutSurvey")
			self.presentViewController(surveyVC, animated: true, completion: nil)
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "no thanks", style: .Default) { action in
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	
	

}
