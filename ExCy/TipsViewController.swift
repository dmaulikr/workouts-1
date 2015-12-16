//
//  TipsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 11/30/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
	
	var stringToPass = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let detailVC: VideosAndTipsViewController = segue.destinationViewController as? VideosAndTipsViewController {
			detailVC.tipURL = stringToPass
		}
    }

	@IBAction func exerciseWhileWatchingTV() {
		stringToPass = "http://excy.com/2015/11/24/easily-exercise-with-excy-while-watching-tv/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func takeExcyAnywhere() {
		stringToPass = "http://excy.com/2015/11/17/take-excy-anywhere-for-anytime-exercise/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func getMoreActive() {
		stringToPass = "http://excy.com/2015/11/20/get-more-active-at-work/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func hitExcyHard() {
		stringToPass = "http://excy.com/2015/11/22/hiit-excy-hard-for-total-efficiency/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func doTenShortExcyBursts() {
		stringToPass = "http://excy.com/2015/11/19/do-10-short-excy-bursts-throughout-the-day/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func multiTaskExcyFitness() {
		stringToPass = "http://excy.com/2015/11/23/multi-task-excy-fitness-to-fit-anywhere/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func takeExcyOutside() {
		stringToPass = "http://excy.com/2015/11/20/take-the-excy-portable-cycling-system-outside/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func useExyToDoStrengthening() {
		stringToPass = "http://excy.com/2015/11/09/use-excy-to-do-strengthening-exercises/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func useExcyWithOthers() {
		stringToPass = "http://excy.com/2015/11/11/excy-with-others-and-be-a-positive-role-model-to-those-around-you/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func goBareFootWithExcy() {
		stringToPass = "http://excy.com/2015/11/05/go-barefoot-with-the-excy-portable-exercise-cycle/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func excyCycleYourUpperBody() {
		stringToPass = "http://excy.com/2015/11/03/excy-cycle-your-upper-body-like-upper-body-ergometer/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func workoutOnTheFloor() {
		stringToPass = "http://excy.com/2015/10/29/workout-on-the-floor-with-the-excy-portable-exercise-cycle/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func varyYourWorkouts() {
		stringToPass = "http://excy.com/2015/10/26/vary-your-excy-portable-total-body-cycle-workouts/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func increaseYourWeeklyCardiac() {
		stringToPass = "http://excy.com/2015/11/02/increase-your-weekly-cardiac-output/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func makeExerciseAHabit() {
		stringToPass = "http://excy.com/2015/11/15/make-exercise-a-habit-and-be-consistent/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func takeALeisureSpin() {
		stringToPass = "http://excy.com/2015/11/18/take-excy-for-a-leisure-spin/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	@IBAction func useExyToTrainShoulders() {
		stringToPass = "http://excy.com/2015/10/30/use-excy-to-train-for-swimming/"
		performSegueWithIdentifier("TipsToWeb", sender: self)
	}
	
	
	
	
	
}



















