//
//  MoreVC.swift
//  ExCy
//
//  Created by Luke Regan on 3/1/16.
//  Copyright © 2016 LukeRegan. All rights reserved.
//

import UIKit

class MoreVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func purchaseExcy(sender: AnyObject) {
		performSegueWithIdentifier("toWebView", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toWebView" {
			if let detailVC: VideosAndTipsViewController = segue.destinationViewController as? VideosAndTipsViewController {
				detailVC.tipURL = "http://excy.com"
			}
		}
	}

}
