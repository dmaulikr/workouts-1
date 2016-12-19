//
//  SetupStartViewController.swift
//  ExCy
//
//  Created by Luke Regan on 5/26/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

//Timer Variables
var secondsCount:Int = 0
var initialTime:Float = 0.0
//Interval variables
var fastIntervalCount:Int = 0
var slowIntervalCount:Int = 0
var slowBurstStepper = 0
var fastBurstStepper = 0
//var counterInSeconds:Int = 0

class SetupStartViewController: UIViewController {
	
	@IBOutlet var stopwatchLabel: UILabel!
	@IBOutlet weak var slowIntervalLabel: UILabel!
	@IBOutlet weak var fastIntervalLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		resetTimers()
		
	}
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	
	
	
	//used for setting up

	//Helper for steppers
	func updateTimerSettingUI() {
		self.stopwatchLabel.text = StringConversion.timeStringFromSeconds(secondsCount)
	}
	
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
		if secondsCount < 1 {
			secondsCount = 60 * 5
			if fastIntervalCount == 0 && slowIntervalCount == 0 {
				fastIntervalCount = 7
				slowIntervalCount = 7
			}
		}
		WarmUpAlert()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toWebView" {
			if let detailVC: VideosAndTipsViewController = segue.destination as? VideosAndTipsViewController {
				detailVC.tipURL = "http://excy.com"
			}
		}
	}

	@IBAction func dontHaveExcy(_ sender: AnyObject) {
		
	}
	
	
	// Alert Views
	
	func resetTimers(){
		secondsCount = 0
		updateTimerSettingUI()
		fastIntervalCount = 0
		fastIntervalLabel.text = "000"
		slowIntervalCount = 0
		slowIntervalLabel.text = "000"
		slowBurstStepper = 0
		fastBurstStepper = 0
	}
	
	func WarmUpAlert () {
		let alertController = UIAlertController(title: "Would you like to warm up?", message: "A quick 2 minute warm up can really enhance your workout experience and is highly recommended for optimal health", preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "Skip", style: .default) { action in
			//write some code in here if I need to
			self.performSegue(withIdentifier: "workout", sender: self)
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "Warm Up", style: .cancel) { action in
			self.performSegue(withIdentifier: "warmup", sender: self)
		}
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func pauseAlert () {
		let alertController = UIAlertController(title: "Continue?", message: "healthy is... finishing strong!", preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "exit workout", style: .default) { action in
			self.resetTimers()
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "resume", style: .default) { action in
			
		}
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func stopAlert () {
		let alertController = UIAlertController(title: "Workout Complete", message: "", preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "Save", style: .default) { action in
			
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "trash", style: .default) { action in
			self.resetTimers()
		}
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	


}
