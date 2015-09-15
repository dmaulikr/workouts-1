//
//  SetupStartViewController.swift
//  ExCy
//
//  Created by Luke Regan on 5/26/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

//Timer Variables
var minutesCount:Int = 0
var minuteString:String = ""
var secondsCount:Int = 0
var secondString:String = ""
var initialTime:Float = 0.0
//Interval variables
var fastIntervalCount:Int = 0
var slowIntervalCount:Int = 0
var slowBurstStepper = 0
var fastBurstStepper = 0
var counterInSeconds:Int = 0

class SetupStartViewController: UIViewController {
	
	@IBOutlet var stopwatchLabel: UILabel!
	@IBOutlet weak var slowIntervalLabel: UILabel!
	@IBOutlet weak var fastIntervalLabel: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		resetTimers()
		
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
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
		if counterInSeconds < 1 {
			counterInSeconds = 60 * 5
			if fastIntervalCount == 0 && slowIntervalCount == 0 {
				fastIntervalCount = 7
				slowIntervalCount = 7
			}
		}
		WarmUpAlert()
	}

	
	
	// Alert Views
	
	func resetTimers(){
		secondsCount = 0
		minutesCount = 0
		updateTimerSettingUI()
		fastIntervalCount = 0
		fastIntervalLabel.text = "000"
		slowIntervalCount = 0
		slowIntervalLabel.text = "000"
		slowBurstStepper = 0
		fastBurstStepper = 0
	}
	
	func WarmUpAlert () {
		let alertController = UIAlertController(title: "Would you like to warm up?", message: "A quick 2 minute warm up can really enhance your workout experience and is highly recommended for optimal health", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "Skip", style: .Default) { action in
			//write some code in here if I need to
			self.performSegueWithIdentifier("workout", sender: self)
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "Warm Up", style: .Cancel) { action in
			self.performSegueWithIdentifier("warmup", sender: self)
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func pauseAlert () {
		let alertController = UIAlertController(title: "Continue?", message: "healthy is... finishing strong!", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "exit workout", style: .Default) { action in
			self.resetTimers()
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "resume", style: .Default) { action in
			
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func stopAlert () {
		let alertController = UIAlertController(title: "Workout Complete", message: "", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "Save", style: .Default) { action in
			
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "trash", style: .Default) { action in
			self.resetTimers()
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	


}