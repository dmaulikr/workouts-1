//
//  SurveyViewController.swift
//  ExCy
//
//  Created by Luke Regan on 6/14/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse

class SurveyViewController: UIViewController {
	
	

	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var labelOutlet: UILabel!
	@IBOutlet weak var descriptionView: UIView!
	@IBOutlet weak var questionsView: UIImageView!
	@IBOutlet weak var selctedZoneNumber: UISegmentedControl!
	@IBOutlet weak var submitButton: UIButton!
	
	var questionNumber = 0
	var workout: Workout?
	var workoutEnjoyment = "good"
	var workoutLocation = "at work"
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		submitButton.setTitle("submit", for: UIControlState())
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func zoneSelection(_ sender: UISegmentedControl) {
		
		switch questionNumber {
		
		case 0: switch selctedZoneNumber.selectedSegmentIndex {
			case 0: questionsView.image = UIImage(named: "Survey2-1")
					self.workoutEnjoyment = "awful"
			case 1: questionsView.image = UIImage(named: "Survey2-2")
					self.workoutEnjoyment = "bad"
			case 2: questionsView.image = UIImage(named: "Survey2-3")
					self.workoutEnjoyment = "good"
			case 3: questionsView.image = UIImage(named: "Survey2-4")
					self.workoutEnjoyment = "great"
			case 4: questionsView.image = UIImage(named: "Survey2-5")
					self.workoutEnjoyment = "amazing"
			default: questionsView.image = UIImage(named: "Survey2-1")
			}
		case 1: switch selctedZoneNumber.selectedSegmentIndex {
			case 0: questionsView.image = UIImage(named: "Survey3-1")
					self.workoutLocation = "at home"
			case 1: questionsView.image = UIImage(named: "Survey3-2")
					self.workoutLocation = "at home"
			case 2: questionsView.image = UIImage(named: "Survey3-3")
					self.workoutLocation = "at work"
			case 3: questionsView.image = UIImage(named: "Survey3-4")
					self.workoutLocation = "traveling"
			case 4: questionsView.image = UIImage(named: "Survey3-5")
					self.workoutLocation = "on the go"
			default: questionsView.image = UIImage(named: "Survey3-1")
			}
			
		case 2: switch selctedZoneNumber.selectedSegmentIndex {
			case 0: questionsView.image = UIImage(named: "Survey4-1")
			case 1: questionsView.image = UIImage(named: "Survey4-2")
			case 2: questionsView.image = UIImage(named: "Survey4-3")
			case 3: questionsView.image = UIImage(named: "Survey4-4")
			case 4: questionsView.image = UIImage(named: "Survey4-5")
			default: questionsView.image = UIImage(named: "Survey4-1")
			}

		default: switch selctedZoneNumber.selectedSegmentIndex {
			case 0: questionsView.image = UIImage(named: "Survey4-1")
			case 1: questionsView.image = UIImage(named: "Survey4-2")
			case 2: questionsView.image = UIImage(named: "Survey4-3")
			case 3: questionsView.image = UIImage(named: "Survey4-4")
			case 4: questionsView.image = UIImage(named: "Survey4-5")
			default: questionsView.image = UIImage(named: "Survey4-1")
			}
		}
		
		
	}
	
	@IBAction func submitButtonPressed(_ sender: UIButton) {
		if questionNumber >= 2 {
			if self.workout != nil {
				self.workout!.addLocationAndEnjoyment(workoutLocation, enjoyment: workoutEnjoyment)
				postToFirebase()
				let completedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarCtrl")
				self.present(completedVC, animated: true, completion: nil)
			} else {
				let completedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarCtrl")
				self.present(completedVC, animated: true, completion: nil)
			}
			
		} else {
			questionNumber += 1
			switch questionNumber {
			case 1: questionsView.image = UIImage(named: "Survey3-3")
					questionLabel.text = "Using the slider below, please let us know where you worked out today."
			case 2: questionsView.image = UIImage(named: "Survey4-3")
					questionLabel.text = "Using the below slider, what best describes how you feel after today's excy workout?"
					submitButton.setTitle("complete", for: UIControlState())
			default: questionLabel.text = "Using the slider below, please rate your average exercise intensity throughout today's workout"
			}
		}
		labelOutlet.isHidden = true
	}
	
	func postToFirebase() {
		guard let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String else {
			let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
			self.present(loginVC, animated: true, completion: nil)
			return
		}
		let dictionaryWorkout = workout!.convertToDictionarySurvey()
		let firebaseWorkout = DataSerice.ds.REF_WORKOUTS.child(uid).childByAutoId()
		firebaseWorkout.setValue(dictionaryWorkout)
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
