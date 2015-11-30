//
//  IntervalWorkoutViewController.swift
//  ExCy
//
//  Created by Luke Regan on 5/3/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse
import AudioToolbox

class IntervalWorkoutViewController: UIViewController {

	@IBOutlet weak var progressView: ProgressView!
	@IBOutlet var stopwatchLabel: UILabel!
	@IBOutlet weak var slowIntervalLabel: UILabel!
	@IBOutlet weak var fastIntervalLabel: UILabel!
	@IBOutlet weak var chartImage: UIImageView!
	@IBOutlet weak var pacingHelperLabel: UILabel!
	
	//Local Save
	var object: PFObject!
	var willCompleteSurvey = false
	var minTemp: Int = 0
	var maxTemp: Int = 0
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
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if self.countdownTimer?.valid == nil {
			
			self.minAlert()
			
		}
	}
	
	func startWorkout () {
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
	
// Parse Query
	func saveWorkout() {
		self.object = PFObject(className: "Workout")
		let seconds = Int(self.initialTime) - counterInSeconds
		self.object["username"] = PFUser.currentUser()!.username
		self.object["title"] = "Interval Workout"
		self.object["timeWorkedOut"] = StringConversion.timeStringFromSeconds(seconds)
		self.object["caloriesBurned"] = (Double(seconds) / 60) * 15
		self.object["minTemp"] = minTemp
		self.object["maxTemp"] = maxTemp
		let date = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE hh:mm a"
		self.object["date"] = dateFormatter.stringFromDate(date)
		
		
		if willCompleteSurvey == true {
			self.performSegueWithIdentifier("surveyFromInterval", sender: self)
		} else {
			self.object["enjoyment"] = "Rank"
			self.object["intensity"] = "Power"
			self.object["location"] = "at home"
			self.object.saveEventually { (success, error) -> Void in
				if (error == nil){
					
				} else {
					print(error!.userInfo)
				}
			}
		}
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "surveyFromInterval" {
			let surveyVC: SurveyViewController = segue.destinationViewController as! SurveyViewController
			let object: PFObject = self.object as PFObject
			surveyVC.object = object
		}
	}

	
// UI updaters
	func timerRun() {
		if counterInSeconds > 0 {
			counterInSeconds--
			self.stopwatchLabel.text = StringConversion.timeStringFromSeconds(counterInSeconds)
			progressCounter++
			shouldChangeIntervalSpeed()
			
			self.progressView.progress = CGFloat(progressCounter) / CGFloat(initialTime)
			self.progressView.setNeedsDisplay()
			
		} else {
			countdownTimer?.invalidate()
			countdownTimer = nil
			maxAlert()
		}
	}
	

	//used for "saving" the workout
	
	
	
// Intervals Logic
	
	func colorWillSwithToRed (red:Bool) {
		if red == false {
			AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
			self.chartImage.image = UIImage(named: "BurstPlayBlue.png")
			self.pacingHelperLabel.text = "slow it down"
			self.pacingHelperLabel.textColor = UIColor(red: 30/255, green: 188/255, blue: 255/255, alpha: 1)
		} else {
			AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
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
				slowBurstStepper++
			} else if slowBurstStepper == slowIntervalCount {
				imageBool = false
				colorWillSwithToRed(true)
				slowBurstStepper = 0
			}
		} else if imageBool == false {
			if fastBurstStepper < fastIntervalCount {
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
		self.stopwatchLabel.text = StringConversion.timeStringFromSeconds(counterInSeconds)
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
		maxAlert()
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
	
	
	// Alerts
	func minAlert () {
		let alertController = UIAlertController(title: "Minimum Temperature", message: "enter the current temperature on the excy thermometer", preferredStyle: .Alert)
		let cancelAction = UIAlertAction(title: "skip", style: .Destructive) { action in
			self.startWorkout()
		}
		alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
			textField.placeholder = "min temperature"
			textField.keyboardType = .NumberPad
		}
		let OKAction = UIAlertAction(title: "Enter", style: .Cancel) { action in
			self.minTemp = Int((alertController.textFields!.first)!.text!)!
			self.startWorkout()
		}
		alertController.addAction(OKAction)
		alertController.addAction(cancelAction)
		
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	func maxAlert () {
		let alertController = UIAlertController(title: "Maximum Temperature", message: "enter the maximum temperature reached while exercising", preferredStyle: .Alert)
		let cancelAction = UIAlertAction(title: "skip", style: .Destructive) { action in
			self.stopAlert()
		}
		alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
			textField.placeholder = "max temperature"
			textField.keyboardType = .NumberPad
		}
		let OKAction = UIAlertAction(title: "Enter", style: .Cancel) { action in
			self.maxTemp = Int((alertController.textFields!.first)!.text!)!
			self.stopAlert()
		}
		alertController.addAction(OKAction)
		alertController.addAction(cancelAction)
		
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	
	
	
	
	func pauseAlert () {
		let alertController = UIAlertController(title: "Continue?", message: "healthy is... finishing strong!", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "exit", style: .Destructive) { action in
			self.resetTimers()
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
			self.resetTimers()
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
		let alertController = UIAlertController(title: "track results?", message: "Please take a moment to track results to monitor your progress", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "yes", style: .Default) { action in
			self.willCompleteSurvey = true
			self.saveWorkout()
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "no thanks", style: .Cancel) { action in
			self.willCompleteSurvey = false
			self.saveWorkout()
			self.resetTimers()
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	


}
