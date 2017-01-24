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
	var workout: Workout?
	var willCompleteSurvey = false
	var minTemp: Int = 0
	var maxTemp: Int = 0
//Timer Variables
	var countdownTimer:Timer?
	var progressCounter:Int = 1
	var initialTime:Float = 0.0
//Interval variables
	var intervalTime:Int = 0
	var intervalMultiplier:Double = 0
	var imageBool = true

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if self.countdownTimer?.isValid == nil {
			
			self.minAlert()
			
		}
	}
	
	func startWorkout () {
		self.initialTime = Float(secondsCount)
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
		self.pacingHelperLabel.isHidden = false
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	func saveWorkout() {
		guard let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
			self.present(loginVC, animated: true, completion: nil)
			return
		}
		let seconds = Int(self.initialTime) - secondsCount
		workout = Workout(workoutTitle: "Interval Workout", time: seconds, uid: uid, minTemp: minTemp , maxTemp: maxTemp)
		
		if willCompleteSurvey == true {
			self.performSegue(withIdentifier: "surveyFromInterval", sender: self)
		} else {
			postToFirebase()
		}
		
	}
	
	func postToFirebase() {
		guard let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
			self.present(loginVC, animated: true, completion: nil)
			return
		}
		let seconds = Int(self.initialTime) - secondsCount
		let workout = Workout(workoutTitle: "Interval Workout", time: seconds, uid: uid, minTemp: minTemp , maxTemp: maxTemp)
		let dictionaryWorkout = workout.convertToDictionaryWithoutSurvey()
		let firebaseWorkout = DataSerice.ds.REF_WORKOUTS.child(byAppendingPath: uid).childByAutoId()
		firebaseWorkout.setValue(dictionaryWorkout)
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "surveyFromInterval" {
			let surveyVC: SurveyViewController = segue.destination as! SurveyViewController
			let workout = self.workout
			surveyVC.workout = workout
		}
	}

	
// UI updaters
	func timerRun() {
		if secondsCount > 0 {
			secondsCount -= 1
			self.stopwatchLabel.text = StringConversion.timeStringFromSeconds(secondsCount)
			progressCounter += 1
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
	
	func colorWillSwithToRed (_ red:Bool) {
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
				slowBurstStepper += 1
			} else if slowBurstStepper == slowIntervalCount {
				imageBool = false
				colorWillSwithToRed(true)
				slowBurstStepper = 0
			}
		} else if imageBool == false {
			if fastBurstStepper < fastIntervalCount {
				fastBurstStepper += 1
			} else if fastBurstStepper == fastIntervalCount {
				imageBool = true
				colorWillSwithToRed(false)
				fastBurstStepper = 0
			}
		}
	}
	
	
	
// Interval Steppers
	@IBAction func minuteTimeUp(_ sender: UIButton) {
		secondsCount += 60
		updateTimerSettingUI()
	}
	@IBAction func minuteTimeDown(_ sender: UIButton) {
		if secondsCount > 60 {
			secondsCount += -60
		}
		updateTimerSettingUI()
	}
	@IBAction func secondTimeUp(_ sender: UIButton) {
		secondsCount += 1
		updateTimerSettingUI()
	}
	@IBAction func secondTimeDown(_ sender: UIButton) {
		if secondsCount > 1 {
			secondsCount -= 1
		}
		updateTimerSettingUI()
	}
	//Helper for steppers
	func updateTimerSettingUI() {
		self.stopwatchLabel.text = StringConversion.timeStringFromSeconds(secondsCount)
	}
	
	
	@IBAction func slowIntervalUp(_ sender: UIButton) {
		slowIntervalCount += 1
		slowIntervalLabel.text = "\(slowIntervalCount)"
	}
	@IBAction func slowIntervalDown(_ sender: UIButton) {
		if slowIntervalCount > 0 {
			slowIntervalCount -= 1
		}
		slowIntervalLabel.text = "\(slowIntervalCount)"
	}
	@IBAction func fastIntervalUp(_ sender: UIButton) {
		fastIntervalCount += 1
		fastIntervalLabel.text = "\(fastIntervalCount)"
	}
	@IBAction func fastIntervalDown(_ sender: UIButton) {
		if fastIntervalCount > 0{
			fastIntervalCount -= 1
		}
		fastIntervalLabel.text = "\(fastIntervalCount)"
	}
	
	
	
// Start Stop and Pause Buttons
	
	@IBAction func startButtonPressed(_ sender: UIButton)
	{
		self.initialTime = Float(secondsCount)
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
	@IBAction func pauseButtonPressed(_ sender: UIButton)
	{
		self.setTimer()
		pauseAlert()
	}
	@IBAction func stopButtomPressed(_ sender: UIButton)
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
			countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(IntervalWorkoutViewController.timerRun), userInfo: nil, repeats: true)
		}
	}
	
	
// Alert Views
	
	func resetTimers(){
		secondsCount = 0
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
		let alertController = UIAlertController(title: "Minimum Temperature", message: "enter the current temperature on the excy thermometer", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "skip", style: .destructive) { action in
			self.startWorkout()
		}
		alertController.addTextField { (textField) -> Void in
			textField.placeholder = "min temperature"
			textField.keyboardType = .numberPad
		}
		let OKAction = UIAlertAction(title: "Enter", style: .cancel) { action in
			if let temp = alertController.textFields?.first?.text {
				self.minTemp = Int(temp)!
			}
			self.startWorkout()
		}
		alertController.addAction(OKAction)
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	func maxAlert () {
		let alertController = UIAlertController(title: "Maximum Temperature", message: "enter the maximum temperature reached while exercising", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "skip", style: .destructive) { action in
			self.stopAlert()
		}
		alertController.addTextField { (textField) -> Void in
			textField.placeholder = "max temperature"
			textField.keyboardType = .numberPad
		}
		let OKAction = UIAlertAction(title: "Enter", style: .cancel) { action in
			if let temp = alertController.textFields?.first?.text {
				self.maxTemp = Int(temp)!
			}
			self.stopAlert()
		}
		alertController.addAction(OKAction)
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	
	
	
	
	func pauseAlert () {
		let alertController = UIAlertController(title: "Continue?", message: "healthy is... finishing strong!", preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "exit", style: .destructive) { action in
			self.resetTimers()
			self.navigationController?.popToRootViewController(animated: true)
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "resume", style: .cancel) { action in
			self.setTimer()
		}
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func stopAlert () {
		let alertController = UIAlertController(title: "Workout Complete", message: "", preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "save", style: .default) { action in
			self.surveyAlert()
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "trash and exit", style: .destructive) { action in
			self.resetTimers()
			self.navigationController?.popToRootViewController(animated: true)
		}
		alertController.addAction(cancelAction)
		let continueAction = UIAlertAction(title: "Resume Workout", style: .cancel) { action in
			self.setTimer()
		}
		alertController.addAction(continueAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func surveyAlert () {
		let alertController = UIAlertController(title: "track results?", message: "Please take a moment to track results to monitor your progress", preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "yes", style: .default) { action in
			self.willCompleteSurvey = true
			self.saveWorkout()
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "no thanks", style: .cancel) { action in
			self.willCompleteSurvey = false
			self.saveWorkout()
			self.resetTimers()
			self.navigationController?.popToRootViewController(animated: true)
		}
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	


}
