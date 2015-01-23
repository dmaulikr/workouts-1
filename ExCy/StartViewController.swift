//
//  StartViewController.swift
//  ExCy
//
//  Created by Luke Regan on 11/20/14.
//  Copyright (c) 2014 LukeRegan. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

	@IBOutlet var stopwatchLabel: UILabel!
	var startTime = NSTimeInterval()
	var timer = NSTimer()

	@IBAction func startButtonPressed(sender: UIButton)
	{
		if !timer.valid {
			let aSelector : Selector = Selector("updateTime")
			timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
			startTime = NSDate.timeIntervalSinceReferenceDate()
		}
	}
	@IBAction func pauseButtonPressed(sender: UIButton)
	{
		timer.invalidate()
	}
	@IBAction func stopButtomPressed(sender: UIButton)
	{
		timer.invalidate()
		stopwatchLabel.text = "00:00"
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func updateTime() {
		var currentTime = NSDate.timeIntervalSinceReferenceDate()
  
		//Find the difference between current time and start time.
		var elapsedTime: NSTimeInterval = currentTime - startTime
  
		//calculate the minutes in elapsed time.
		let minutes = UInt8(elapsedTime / 60.0)
		elapsedTime -= (NSTimeInterval(minutes) * 60)
  
		//calculate the seconds in elapsed time.
		let seconds = UInt8(elapsedTime)
		elapsedTime -= NSTimeInterval(seconds)
  
		//find out the fraction of milliseconds to be displayed.
		let fraction = UInt8(elapsedTime * 100)
  
		//add the leading zero for minutes, seconds and millseconds and store them as string constants
		let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
		let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
		let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
  
		//concatenate minuets, seconds and milliseconds as assign it to the UILabel
		stopwatchLabel.text = "\(strMinutes):\(strSeconds)"
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
