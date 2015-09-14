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
	
	var timer: NSTimer?
	var warmupTime: Int = 119
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateUI"), userInfo: nil, repeats: true)
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		self.timer?.invalidate()
	}
	
	func stringConversion (seconds:Int) -> String {
		var minutesCount = seconds / 60
		var secondsCount = seconds - (minutesCount * 60)
		var minuteString = String(minutesCount)
		var secondString = String(secondsCount)
		if secondsCount < 10 { secondString = "0\(secondsCount)"}
		else { secondString = "\(secondsCount)" }
		if minutesCount < 10 { minuteString = "0\(minutesCount)"}
		else { minuteString = "\(minutesCount)" }
		return "\(minuteString):\(secondString)"
	}
	
	
	func updateUI() {
		if warmupTime > 0 {
			self.stopWatchLabel.text = stringConversion(warmupTime)
			warmupTime--
		} else {
			PerformSelectedSegue()
		}
		
	}
	func PerformSelectedSegue () {
		switch warmupCompletionSegue {
		case 1: self.performSegueWithIdentifier("WarmUpArmCandy", sender: self)
		case 2: self.performSegueWithIdentifier("WarmUpSuperCycle", sender: self)
		case 3: self.performSegueWithIdentifier("WarmUpCycleLeg", sender: self)
		case 4: self.performSegueWithIdentifier("WarmUpCoreFloor", sender: self)
		case 5: self.performSegueWithIdentifier("WarmUpArmBlast", sender: self)
		case 6: self.performSegueWithIdentifier("WarmUpUltimate", sender: self)
		default: performSegueWithIdentifier("WarmUpSuperCycle", sender: self)
		}
	}
	
	@IBAction func pauseButtonPressed(sender: UIButton) {
		
	}
	
	
	@IBAction func stopButtonPressed(sender: UIButton) {
		PerformSelectedSegue()
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
