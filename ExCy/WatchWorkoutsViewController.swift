//
//  WatchWorkoutsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 11/29/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import UIKit

class WatchWorkoutsViewController: UIViewController {
	
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let detailVC: VideosAndTipsViewController = segue.destination as? VideosAndTipsViewController {
			detailVC.youtubeURL = stringToPass
		}
		
	}
	
	
	
	@IBAction func armCandyVideo() {
		stringToPass = "<iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height / 2)\" src=\"https://www.youtube.com/embed/0eONwwRUIJc\" frameborder=\"0\" allowfullscreen></iframe>"
		performSegue(withIdentifier: "WatchVideos", sender: self)
	}
	
	@IBAction func superCycleVideo() {
		stringToPass = "<iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height / 2)\" src=\"https://www.youtube.com/embed/tSRh26o3zaI\" frameborder=\"0\" allowfullscreen></iframe>"
		performSegue(withIdentifier: "WatchVideos", sender: self)
	}
	
	@IBAction func cycleLegVideo() {
		stringToPass = "<iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height / 2)\" src=\"https://www.youtube.com/embed/aIxytWycNhg\" frameborder=\"0\" allowfullscreen></iframe>"
		performSegue(withIdentifier: "WatchVideos", sender: self)
	}
	
	@IBAction func coreFloorVideo() {
		stringToPass = "<iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height / 2)\" src=\"https://www.youtube.com/embed/RA-dtZcF75c\" frameborder=\"0\" allowfullscreen></iframe>"
		performSegue(withIdentifier: "WatchVideos", sender: self)
	}
	
	@IBAction func armBlastVideo() {
		stringToPass = "<iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height / 2)\" src=\"https://www.youtube.com/embed/4k7JUFgF57M\" frameborder=\"0\" allowfullscreen></iframe>"
		performSegue(withIdentifier: "WatchVideos", sender: self)
	}
	
	@IBAction func armLegVideo() {
		stringToPass = "<iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height / 2)\" src=\"https://www.youtube.com/embed/QnwdAfD3XLI\" frameborder=\"0\" allowfullscreen></iframe>"
		performSegue(withIdentifier: "WatchVideos", sender: self)
	}
	
	
	
}
