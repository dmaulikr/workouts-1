//
//  SurveyViewController.swift
//  ExCy
//
//  Created by Luke Regan on 6/14/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {

	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var labelOutlet: UILabel!
	@IBOutlet weak var descriptionView: UIView!
	@IBOutlet weak var questionsView: UIImageView!
	@IBOutlet weak var selctedZoneNumber: UISegmentedControl!
	@IBOutlet weak var submitButton: UIButton!
	
	var questionNumber = 0
	var surveryQuestions: [Int]?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)
		submitButton.setTitle("submit", forState: UIControlState.Normal)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func zoneSelection(sender: UISegmentedControl) {
		
		switch questionNumber {
			
		case 0: switch selctedZoneNumber.selectedSegmentIndex {
				case 0: questionsView.image = UIImage(named: "Survey1-1")
					surveryQuestions?.append(1)
				case 1: questionsView.image = UIImage(named: "Survey1-2")
					surveryQuestions?.append(2)
				case 2: questionsView.image = UIImage(named: "Survey1-3")
					surveryQuestions?.append(3)
				case 3: questionsView.image = UIImage(named: "Survey1-4")
					surveryQuestions?.append(4)
				case 4: questionsView.image = UIImage(named: "Survey1-5")
					surveryQuestions?.append(5)
				default: questionsView.image = UIImage(named: "Survey1-1")
					surveryQuestions?.append(3)
			}
		case 1: switch selctedZoneNumber.selectedSegmentIndex {
				case 0: questionsView.image = UIImage(named: "Survey2-1")
					surveryQuestions?.append(1)
				case 1: questionsView.image = UIImage(named: "Survey2-2")
					surveryQuestions?.append(2)
				case 2: questionsView.image = UIImage(named: "Survey2-3")
					surveryQuestions?.append(3)
				case 3: questionsView.image = UIImage(named: "Survey2-4")
					surveryQuestions?.append(4)
				case 4: questionsView.image = UIImage(named: "Survey2-5")
					surveryQuestions?.append(5)
				default: questionsView.image = UIImage(named: "Survey2-1")
					surveryQuestions?.append(3)
			}
		case 2: switch selctedZoneNumber.selectedSegmentIndex {
				case 0: questionsView.image = UIImage(named: "Survey3-1")
					surveryQuestions?.append(1)
				case 1: questionsView.image = UIImage(named: "Survey3-2")
					surveryQuestions?.append(2)
				case 2: questionsView.image = UIImage(named: "Survey3-3")
					surveryQuestions?.append(3)
				case 3: questionsView.image = UIImage(named: "Survey3-4")
					surveryQuestions?.append(4)
				case 4: questionsView.image = UIImage(named: "Survey3-5")
					surveryQuestions?.append(5)
				default: questionsView.image = UIImage(named: "Survey3-1")
					surveryQuestions?.append(3)
			}
			
		case 3: switch selctedZoneNumber.selectedSegmentIndex {
				case 0: questionsView.image = UIImage(named: "Survey4-1")
					surveryQuestions?.append(1)
				case 1: questionsView.image = UIImage(named: "Survey4-2")
					surveryQuestions?.append(2)
				case 2: questionsView.image = UIImage(named: "Survey4-3")
					surveryQuestions?.append(3)
				case 3: questionsView.image = UIImage(named: "Survey4-4")
					surveryQuestions?.append(4)
				case 4: questionsView.image = UIImage(named: "Survey4-5")
					surveryQuestions?.append(5)
				default: questionsView.image = UIImage(named: "Survey4-1")
					surveryQuestions?.append(3)
			}

		default: switch selctedZoneNumber.selectedSegmentIndex {
				case 0: questionsView.image = UIImage(named: "Survey1-1")
					surveryQuestions?.append(1)
				case 1: questionsView.image = UIImage(named: "Survey1-2")
					surveryQuestions?.append(2)
				case 2: questionsView.image = UIImage(named: "Survey1-3")
					surveryQuestions?.append(3)
				case 3: questionsView.image = UIImage(named: "Survey1-4")
					surveryQuestions?.append(4)
				case 4: questionsView.image = UIImage(named: "Survey1-5")
					surveryQuestions?.append(5)
				default: questionsView.image = UIImage(named: "Survey1-1")
					surveryQuestions?.append(3) }
		}
		
		
	}
	
	@IBAction func submitButtonPressed(sender: UIButton) {
		if questionNumber >= 3 {
			let completedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabBarCtrl")
			self.presentViewController(completedVC, animated: true, completion: nil)
		} else {
			questionNumber++
			switch questionNumber {
			case 1: questionsView.image = UIImage(named: "Survey2-3")
					questionLabel.text = "Using the slider below, please let us know how you rate today's workout experience."
			case 2: questionLabel.text = "Using the slider below, please let us know where you worked out today."
					questionsView.image = UIImage(named: "Survey3-3")
			case 3: questionLabel.text = "Using the below slider, what best describes how you feel after today's excy workout?"
					questionsView.image = UIImage(named: "Survey4-3")
				submitButton.setTitle("complete", forState: UIControlState.Normal)
			default: questionLabel.text = "Using the slider below, please rate your average exercise intensity throughout today's workout"
			}
		}
		labelOutlet.hidden = true
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
