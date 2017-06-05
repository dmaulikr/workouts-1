//
//  WarmupWorkoutsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 6/1/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

class WarmupWorkoutsViewController: UIViewController {

	@IBOutlet weak var stopWatchLabel: UILabel!
	
	var workoutNumber: Int?
	var timer: Timer?
	var warmupTime: Int = 119
    var isCounting = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WarmupWorkoutsViewController.updateUI), userInfo: nil, repeats: true)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.timer?.invalidate()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let identifier = segue.identifier {
			if identifier == "FromWarmUpToWorkout" {
				if let detailVC: WorkoutsViewController = segue.destination as? WorkoutsViewController {
					detailVC.workoutNumber = workoutNumber
				}
				
			}
		}
	}
	
	
	func updateUI() {
		if warmupTime > 0 {
			self.stopWatchLabel.text = StringConversion.timeStringFromSeconds(warmupTime)
			warmupTime -= 1
		} else {
			performSegue(withIdentifier: "FromWarmUpToWorkout", sender: self)
		}
		
	}
	
	@IBAction func pauseButtonPressed(_ sender: UIButton) {
        if isCounting {
            timer?.invalidate()
            isCounting = !isCounting
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WarmUpViewController.updateUI), userInfo: nil, repeats: true)
            isCounting = !isCounting
        }
	}
	
	
	@IBAction func stopButtonPressed(_ sender: UIButton) {
		performSegue(withIdentifier: "FromWarmUpToWorkout", sender: self)
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
