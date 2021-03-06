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

	@IBAction func armCandyButtonPressed(_ sender: UIButton) {
		
		switch sender.tag {
		case 1:
			workoutNumber = 1
			workoutTime = 420
			WarmUpAlert()
		case 2:
			workoutNumber = 2
			workoutTime = 1380
			WarmUpAlert()
		case 3:
			workoutNumber = 3
			workoutTime = 900
			WarmUpAlert()
		case 4:
			workoutNumber = 4
			workoutTime = 600
			WarmUpAlert()
		case 5:
			workoutNumber = 5
			workoutTime = 600
			WarmUpAlert()
		case 6:
			workoutNumber = 6
			workoutTime = 420
			WarmUpAlert()
		default:
			workoutNumber = 1
			workoutTime = 420
			WarmUpAlert()
		}
	}

	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let identifier = segue.identifier {
			if identifier == "selectedWorkoutSegue" {
				if let detailVC: WorkoutsViewController = segue.destination as? WorkoutsViewController {
					detailVC.workoutNumber = workoutNumber
				}
			}else if segue.identifier == "warmUpWorkout" {
				if let detailVC: WarmupWorkoutsViewController = segue.destination as? WarmupWorkoutsViewController {
					detailVC.workoutNumber = workoutNumber
				}

			} else if segue.identifier == "toWebView" {
				if let detailVC: VideosAndTipsViewController = segue.destination as? VideosAndTipsViewController {
					detailVC.tipURL = "http://excy.com"
				}
			}
		}
	}
	
	
	@IBAction func dontHaveExcy(_ sender: AnyObject) {
		
	}
	
	func WarmUpAlert () {
		
		let alertController = UIAlertController(title: "Would you like to warm up?", message: "A quick 2 minute warm up can really enhance your workout experience and is highly recommended for optimal health", preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "Skip", style: .default) { action in
			self.performSegue(withIdentifier: "selectedWorkoutSegue", sender: self)
		}
		
		alertController.addAction(OKAction)
		let cancelAction = UIAlertAction(title: "Warm Up", style: .cancel) { action in
			self.performSegue(withIdentifier: "warmUpWorkout", sender: self)
		}
		
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
}
