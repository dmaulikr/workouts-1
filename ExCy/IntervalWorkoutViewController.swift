//
//  IntervalWorkoutViewController.swift
//  ExCy
//
//  Created by Luke Regan on 5/3/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

class IntervalWorkoutViewController: UIViewController {

	@IBOutlet weak var progressView: ProgressView!
	@IBOutlet var stopwatchLabel: UILabel!
	@IBOutlet weak var slowIntervalLabel: UILabel!
	@IBOutlet weak var fastIntervalLabel: UILabel!
	@IBOutlet weak var chartImage: UIImageView!
	@IBOutlet weak var pacingHelperLabel: UILabel!
	
//Timer Variables
	var countdownTimer:NSTimer?
	var progressCounter:Int = 1
	var initialTime:Float = 0.0
//Interval variables
	var intervalTime:Int = 0
	var intervalMultiplier:Double = 0
	var imageBool = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let defaults = NSUserDefaults.standardUserDefaults()
		if let savedWorkouts = defaults.objectForKey("workouts") as? NSData {
			workouts = NSKeyedUnarchiver.unarchiveObjectWithData(savedWorkouts) as! [Workouts]
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.initialTime = Float(counterInSeconds)
		if fastIntervalCount == 0 && slowIntervalCount == 0 {
			intervalTime = 5
		} else {
			intervalTime = Int(initialTime) / (fastIntervalCount + slowIntervalCount)
			if fastIntervalCount > slowIntervalCount {
				colorWillSwithToRed(true)
				imageBool = false
			} else if fastIntervalCount <= slowIntervalCount {
				colorWillSwithToRed(false)
			}
		}
		self.setTimer()
		slowIntervalLabel.text = "\(slowIntervalCount)"
		fastIntervalLabel.text = "\(fastIntervalCount)"
		self.pacingHelperLabel.hidden = false
		
		
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
// UI updaters
	func timerRun() {
		if counterInSeconds > 0 {
			counterInSeconds--
			self.stopwatchLabel.text = stringConversion(counterInSeconds)
			progressCounter++
			shouldChangeIntervalSpeed()
			
			self.progressView.progress = CGFloat(progressCounter) / CGFloat(initialTime)
			self.progressView.setNeedsDisplay()
			
		} else {
			countdownTimer?.invalidate()
			countdownTimer = nil
			stopAlert()
		}
	}
	
	
	
	//used for setting up
	
	func stringConversion (seconds:Int) -> String {
		minutesCount = seconds / 60
		secondsCount = seconds - (minutesCount * 60)
		if secondsCount < 10 { secondString = "0\(secondsCount)"}
		else { secondString = "\(secondsCount)" }
		if minutesCount < 10 { minuteString = "0\(minutesCount)"}
		else { minuteString = "\(minutesCount)" }
		return "\(minuteString):\(secondString)"
	}
	
	//used for "saving" the workout
	
	
	
// Intervals Logic
	
	func colorWillSwithToRed (red:Bool) {
		if red == false {
			self.chartImage.image = UIImage(named: "BurstPlayBlue.png")
			self.pacingHelperLabel.text = "slow it down"
			self.pacingHelperLabel.textColor = UIColor(red: 30/255, green: 188/255, blue: 255/255, alpha: 1)
		} else {
			chartImage.image = UIImage(named: "BurstPlayRed.png")
			self.pacingHelperLabel.text = "push yourself"
			self.pacingHelperLabel.textColor = UIColor(red: 238/255, green: 47/255, blue: 70/255, alpha: 1)
		}
		
	}
	
	func shouldChangeIntervalSpeed () {
		if intervalTime > 0 {
			if slowIntervalCount > 0 && fastIntervalCount > 0 {
				intervalChange()
			} else if slowIntervalCount > 0 {
				colorWillSwithToRed(false)
			} else if fastIntervalCount > 0 {
				colorWillSwithToRed(true)
			}
		}
	}
	
	func intervalChange () {
		if imageBool == true {
			if slowBurstStepper < slowIntervalCount {
				print("I'm evaluating blue")
				slowBurstStepper++
			} else if slowBurstStepper == slowIntervalCount {
				imageBool = false
				colorWillSwithToRed(true)
				slowBurstStepper = 0
			}
		} else if imageBool == false {
			if fastBurstStepper < fastIntervalCount {
				print(" I'm evaluating red")
				fastBurstStepper++
			} else if fastBurstStepper == fastIntervalCount {
				imageBool = true
				colorWillSwithToRed(false)
				fastBurstStepper = 0
			}
		}
		
	}
	
	
	
// Interval Steppers
	@IBAction func minuteTimeUp(sender: UIButton) {
		minutesCount++
		updateTimerSettingUI()
	}
	@IBAction func minuteTimeDown(sender: UIButton) {
		if minutesCount > 0 {
			minutesCount--
		}
		updateTimerSettingUI()
	}
	@IBAction func secondTimeUp(sender: UIButton) {
		secondsCount++
		updateTimerSettingUI()
	}
	@IBAction func secondTimeDown(sender: UIButton) {
		if secondsCount > 1 {
			secondsCount--
		}
		updateTimerSettingUI()
	}
	//Helper for steppers
	func updateTimerSettingUI() {
		counterInSeconds = (minutesCount * 60) + secondsCount
		self.stopwatchLabel.text = stringConversion(counterInSeconds)
	}
	
	
	@IBAction func slowIntervalUp(sender: UIButton) {
		slowIntervalCount++
		slowIntervalLabel.text = "\(slowIntervalCount)"
	}
	@IBAction func slowIntervalDown(sender: UIButton) {
		if slowIntervalCount > 0 {
			slowIntervalCount--
		}
		slowIntervalLabel.text = "\(slowIntervalCount)"
	}
	@IBAction func fastIntervalUp(sender: UIButton) {
		fastIntervalCount++
		fastIntervalLabel.text = "\(fastIntervalCount)"
	}
	@IBAction func fastIntervalDown(sender: UIButton) {
		if fastIntervalCount > 0{
			fastIntervalCount--
		}
		fastIntervalLabel.text = "\(fastIntervalCount)"
	}
	
	
	
// Start Stop and Pause Buttons
	
	@IBAction func startButtonPressed(sender: UIButton)
	{
		self.initialTime = Float(counterInSeconds)
		if fastIntervalCount == 0 && slowIntervalCount == 0 {
			intervalTime = 5
		} else {
			intervalTime = Int(initialTime) / (fastIntervalCount + slowIntervalCount)
			if fastIntervalCount > slowIntervalCount {
				colorWillSwithToRed(true)
				imageBool = false
			} else if fastIntervalCount <= slowIntervalCount {
				colorWillSwithToRed(false)
			}
		}
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
	
//Helper and main Timer Function
	func setTimer(){
		if (countdownTimer != nil) {
			countdownTimer?.invalidate()
			countdownTimer = nil
		} else {
			countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerRun", userInfo: nil, repeats: true)
		}
	}
	
	
// Alert Views
	
	func resetTimers(){
		secondsCount = 0
		minutesCount = 0
		self.progressCounter = 0
		self.updateTimerSettingUI()
		self.chartImage.image = UIImage(named: "BurstPlayGrey.png")
		fastIntervalCount = 0
		self.fastIntervalLabel.text = "000"
		slowIntervalCount = 0
		self.slowIntervalLabel.text = "000"
		slowBurstStepper = 0
		fastBurstStepper = 0
		intervalTime = 0
	}
	
	func saveWorkout() {
		let seconds = Int(self.initialTime) - counterInSeconds
		let totalTimeWorkedOut = stringConversion(seconds)
		let workout = Workouts(workoutTitle: "Interval Workout", time: totalTimeWorkedOut)
		workouts.insert(workout, atIndex: 0)
		let savedData = NSKeyedArchiver.archivedDataWithRootObject(workouts)
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setObject(savedData, forKey: "workouts")
	}
	
	
	func pauseAlert () {
		let alertController = UIAlertController(title: "Continue?", message: "healthy is... finishing strong!", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "save and exit", style: .Default) { action in
			self.saveWorkout()
			self.resetTimers()
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
		let OKAction = UIAlertAction(title: "save", style: .Default) { action in
			self.saveWorkout()
			self.resetTimers()
			self.surveyAlert()
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "trash", style: .Default) { action in
			self.resetTimers()
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
			self.resetTimers()
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	


}
