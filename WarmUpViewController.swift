//
//  WarmUpViewController.swift
//  ExCy
//
//  Created by Luke Regan on 4/17/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

class WarmUpViewController: UIViewController {

	@IBOutlet weak var stopWatchLabel: UILabel!
	
	var timer: Timer?
	var warmupTime: Int = 119
    var isCounting = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WarmUpViewController.updateUI), userInfo: nil, repeats: true)
	}
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.timer?.invalidate()
	}
	
	func updateUI() {
		if warmupTime > 0 {
			self.stopWatchLabel.text = StringConversion.timeStringFromSeconds(warmupTime)
			warmupTime -= 1
		} else {
			performSegue(withIdentifier: "workoutFromWarmup", sender: self)
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
		self.timer?.invalidate()
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
