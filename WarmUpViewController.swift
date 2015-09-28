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
		let minutesCount = seconds / 60
		let secondsCount = seconds - (minutesCount * 60)
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
			performSegueWithIdentifier("workoutFromWarmup", sender: self)
		}
		
	}
	
	@IBAction func pauseButtonPressed(sender: UIButton) {
		
	}
	
	
	@IBAction func stopButtonPressed(sender: UIButton) {
		
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
