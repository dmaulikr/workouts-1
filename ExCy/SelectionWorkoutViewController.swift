//
//  SelectionWorkoutViewController.swift
//  ExCy
//
//  Created by Luke Regan on 5/26/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

var warmupCompletionSegue = 1

class SelectionWorkoutViewController: UIViewController {

	@IBAction func armCandyButtonPressed(sender: UIButton) {
		workoutTime = 420
		warmupCompletionSegue = 1
		WarmUpAlert()
	}
	
	@IBAction func superCycleCardioButtonPressed(sender: UIButton) {
		workoutTime = 1380
		warmupCompletionSegue = 2
		WarmUpAlert()
	}
	
	@IBAction func cycleLetBlastButtonPressed(sender: UIButton) {
		workoutTime = 900
		warmupCompletionSegue = 3
		WarmUpAlert()
	}
	
	@IBAction func coreFloorExplosionButtonPressed(sender: UIButton) {
		workoutTime = 600
		warmupCompletionSegue = 4
		WarmUpAlert()
	}
	
	@IBAction func armBlastButtonPressed(sender: UIButton) {
		workoutTime = 600
		warmupCompletionSegue = 5
		WarmUpAlert()
	}
	
	@IBAction func ultimateArmLegToningButtonPressed(sender: UIButton) {
		workoutTime = 420
		warmupCompletionSegue = 6
		WarmUpAlert()
	}
	
	func PerformSelectedSegue () {
		switch warmupCompletionSegue {
		case 1: self.performSegueWithIdentifier("armCandy", sender: self)
		case 2: self.performSegueWithIdentifier("superCycleCardio", sender: self)
		case 3: self.performSegueWithIdentifier("cycleLegBlast", sender: self)
		case 4: self.performSegueWithIdentifier("coreFloorExplosion", sender: self)
		case 5: self.performSegueWithIdentifier("armBlast", sender: self)
		case 6: self.performSegueWithIdentifier("ultimateArmLeg", sender: self)
		default: performSegueWithIdentifier("superCycleCardio", sender: self)
		}
	}
	
	
	func WarmUpAlert () {
		let alertController = UIAlertController(title: "Would you like to warm up?", message: "A quick 2 minute warm up can really enhance your workout experience and is highly recommended for optimal health", preferredStyle: .Alert)
		let OKAction = UIAlertAction(title: "Skip", style: .Default) { action in
			self.PerformSelectedSegue()
			
		}
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "Warm Up", style: .Cancel) { action in
			
			self.performSegueWithIdentifier("warmUpWorkout", sender: self)
			
			
		}
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}

	
}
