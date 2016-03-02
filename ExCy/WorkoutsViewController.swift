//
//  WorkoutsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 2/16/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
import AudioToolbox
import Firebase

class WorkoutsViewController: UIViewController {
	
	let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
	
	var workoutNumber: Int?
	var workoutTime: Int?
	@IBOutlet weak var workoutButton: UIButton!

	@IBOutlet var zoneImageView: UIImageView!
	@IBOutlet weak var progressView: WorkoutProgressView!
	@IBOutlet var stopwatchLabel: UILabel!
	
	@IBOutlet weak var currentMinZoneLabel: UILabel!
	@IBOutlet weak var targetZoneImageView: UIImageView!
	@IBOutlet weak var audioButton: UIButton!
	
	var timer: NSTimer?
	var progressCounter = 0
	var initialTime: Float = 1
	
	//Local Save
	var workout: Workout!
	var willCompleteSurvey = false
	var workoutName = "Arm Candy"
	
	var zoneBrain: ZoneBrain?
	var zoneIncrementTime = 0
	var zoneArray: [Int]?
	var minTemp: Int = 0
	var maxTemp: Int = 0
	
	var audioPlayer: AVAudioPlayer!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		

	}
	
	override func viewWillAppear(animated: Bool) {
		
		if (timer?.valid != nil) {
			
		} else {
			if let newNumber = workoutNumber {
				switch newNumber {
				case 1: workoutTime = 420
					do { self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ArmCandy", ofType: "m4a")!))
					} catch { print("Error with audio") }
					workoutName = "Arm Candy"
					zoneBrain = ZoneBrain.init(time: 420, zones: 7)
					zoneArray = zoneBrain!.getZoneArray()
				case 2: workoutTime = 1380
					do { self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("SuperCycle", ofType: "m4a")!))
					} catch { print("Error with audio") }
					workoutName = "Super Cycle Cardio"
					zoneBrain = ZoneBrain.init(time: 1380, zones: 23)
					zoneArray = zoneBrain!.getZoneArray()
				case 3: workoutTime = 900
					do { self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("LegBlast", ofType: "mp3")!))
					} catch { print("Error with audio") }
					workoutName = "Cycle Leg Blast"
					zoneBrain = ZoneBrain.init(time: 900, zones: 15)
					zoneArray = zoneBrain!.getZoneArray()
				case 4: workoutTime = 600
					do { self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("CoreFloor", ofType: "mp3")!))
					} catch { print("Error with audio") }
					workoutName = "Core Floor Explosion"
					zoneBrain = ZoneBrain.init(time: 600, zones: 10)
					zoneArray = zoneBrain!.getZoneArray()
				case 5: workoutTime = 600
					do { self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ArmBlast", ofType: "m4a")!))
					} catch { print("Error with audio") }
					workoutName = "Arm Blast"
					zoneBrain = ZoneBrain.init(time: 600, zones: 10)
					zoneArray = zoneBrain!.getZoneArray()
				case 6: workoutTime = 420
					do { self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("UltimateArmLeg", ofType: "m4a")!))
					} catch { print("Error with audio") }
					workoutName = "Ultimate Arm & Leg Toning"
					zoneBrain = ZoneBrain.init(time: 420, zones: 7)
					zoneArray = zoneBrain!.getZoneArray()
				default: workoutTime = 420
					do { self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ArmCandy", ofType: "m4a")!))
					} catch { print("Error with audio") }
					workoutName = "Arm Candy"
					zoneBrain = ZoneBrain.init(time: 420, zones: 7)
					zoneArray = zoneBrain!.getZoneArray()
				}
			}
		}
	}
	
	func startWorkout() {
		self.targetZoneImageView.image = UIImage(named: "ZoneIntensity\(zoneArray!.first!).png")
		self.initialTime = Float(workoutTime!)
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateUI"), userInfo: nil, repeats: true)
		self.audioPlayer.play()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if (timer?.valid != nil) {
			
		} else {
			minAlert()
		}
		
		
	}
	
	@IBAction func muteAudio() {
		if self.audioPlayer.volume > 0 {
			self.audioPlayer.volume = 0
			self.audioButton.alpha = 0.3
		} else {
			self.audioPlayer.volume = 1
			self.audioButton.alpha = 1
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
	
	
	func setUpZoneView() {
		if zoneBrain == nil { return }
		zoneIncrementTime++
		if zoneIncrementTime >= zoneBrain!.zoneChangeInSeconds {
			zoneIncrementTime = 0
			zoneArray?.removeFirst()
			if zoneArray?.count > 0 {
				self.targetZoneImageView.image = UIImage(named: "ZoneIntensity\(zoneArray!.first!).png")
				AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
			}
			
		}
	}
	
	func saveWorkout() {
		let seconds = Int(self.initialTime) - workoutTime!
		workout = Workout(workoutTitle: workoutName, time: seconds, uid: uid, minTemp: minTemp , maxTemp: maxTemp)
		
		if willCompleteSurvey == true {
			self.performSegueWithIdentifier("surveyFromWorkout", sender: self)
		} else {
			postToFirebase()
		}
		
	}
	
	func postToFirebase() {
		let seconds = Int(self.initialTime) - workoutTime!
		let workout = Workout(workoutTitle: workoutName, time: seconds, uid: uid, minTemp: minTemp , maxTemp: maxTemp)
		let dictionaryWorkout = workout.convertToDictionaryWithoutSurvey()
		let firebaseWorkout = DataSerice.ds.REF_WORKOUTS.childByAppendingPath(uid).childByAutoId()
		firebaseWorkout.setValue(dictionaryWorkout)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "surveyFromWorkout" {
			let surveyVC: SurveyViewController = segue.destinationViewController as! SurveyViewController
			let workout = self.workout
			surveyVC.workout = workout
		}
		if segue.identifier == "toWebView" {
			if let detailVC: VideosAndTipsViewController = segue.destinationViewController as? VideosAndTipsViewController {
				detailVC.tipURL = "http://excy.com"
			}
		}
	}

	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	
	func updateUI() {
		if (workoutTime != nil) && workoutTime > 0 {
			workoutTime!--
			self.stopwatchLabel.text = StringConversion.timeStringFromSeconds(workoutTime!) //stringConversion(workoutTime!)
			self.progressCounter++
			
			self.progressView.progress = CGFloat(progressCounter) / CGFloat(initialTime)
			self.progressView.setNeedsDisplay()
			self.setUpZoneView()
			
		} else if workoutTime == 0 {
			self.timer = nil
			maxAlert()
		} else {
			self.timer = nil
			maxAlert()
		}
	}
	
	
	func setTimer(){
		if (self.timer != nil) {
			self.timer?.invalidate()
			self.timer = nil
			self.audioPlayer.pause()
		} else {
			self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateUI", userInfo: nil, repeats: true)
			self.audioPlayer.play()
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
		maxAlert()
	}
	
	@IBAction func purchaseExcy(sender: AnyObject) {
		
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
			if let temp = alertController.textFields?.first?.text {
				self.minTemp = Int(temp)!
				self.currentMinZoneLabel.text = temp
			}
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
			if let temp = alertController.textFields?.first?.text {
				self.maxTemp = Int(temp)!
			}
			self.stopAlert()
		}
		alertController.addAction(OKAction)
		alertController.addAction(cancelAction)
		
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	
	
	
	
	
	func pauseAlert () {
		let alertController = UIAlertController(title: "Continue?", message: "healthy is... finishing strong!", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "exit", style: .Destructive) { action in
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
			self.audioPlayer.stop()
			self.timer?.invalidate()
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
			self.audioPlayer.stop()
			self.timer = nil
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "no thanks", style: .Cancel) { action in
			self.willCompleteSurvey = false
			self.saveWorkout()
			self.audioPlayer.stop()
			self.timer = nil
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	
	

}
