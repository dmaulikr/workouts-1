//
//  SelectionWorkoutViewController.swift
//  ExCy
//
//  Created by Luke Regan on 5/26/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit


class SelectionWorkoutViewController: UIViewController {
	
	var workoutNumber = 1
	var workoutTime: Int?

	@IBAction func armCandyButtonPressed(sender: UIButton) {
		if sender.tag == 1 {
			workoutNumber = 1
			workoutTime = 420
			WarmUpAlert()
		} else if sender.tag == 2 {
			workoutNumber = 2
			workoutTime = 1380
			WarmUpAlert()
		} else if sender.tag == 3 {
			workoutNumber = 3
			workoutTime = 900
			WarmUpAlert()
		} else if sender.tag == 4 {
			workoutNumber = 4
			workoutTime = 600
			WarmUpAlert()
		} else if sender.tag == 5 {
			workoutNumber = 5
			workoutTime = 600
			WarmUpAlert()
		} else if sender.tag == 6 {
			workoutNumber = 6
			workoutTime = 420
			WarmUpAlert()
		}
	}

	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let identifier = segue.identifier {
			if identifier == "selectedWorkoutSegue" {
				if let detailVC: WorkoutsViewController = segue.destinationViewController as? WorkoutsViewController {
					detailVC.workoutNumber = workoutNumber
				}
			}else if segue.identifier == "warmUpWorkout" {
				if let detailVC: WarmupWorkoutsViewController = segue.destinationViewController as? WarmupWorkoutsViewController {
					detailVC.workoutNumber = workoutNumber
				}

			}
		}
	}
	
	
	
	func WarmUpAlert () {
		
		let alertController = UIAlertController(title: "Would you like to warm up?", message: "A quick 2 minute warm up can really enhance your workout experience and is highly recommended for optimal health", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "Skip", style: .Default) { action in
			self.performSegueWithIdentifier("selectedWorkoutSegue", sender: self)
		}
		
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "Warm Up", style: .Cancel) { action in
			self.performSegueWithIdentifier("warmUpWorkout", sender: self)
		}
		
		alertController.addAction(cancelAction)
		
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
}
