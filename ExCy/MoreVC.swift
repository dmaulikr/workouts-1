//
//  MoreVC.swift
//  ExCy
//
//  Created by Luke Regan on 3/1/16.
//  Copyright © 2016 LukeRegan. All rights reserved.
//

import UIKit

class MoreVC: UIViewController {
    
    var liveButtonString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func purchaseExcy(_ sender: AnyObject) {
		performSegue(withIdentifier: "toWebView", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toWebView" {
			if let detailVC: VideosAndTipsViewController = segue.destination as? VideosAndTipsViewController {
				detailVC.tipURL = liveButtonString ?? "http://excy.com"
			}
		}
	}
    @IBAction func liveButtonPressed(_ sender: UIButton) {
        
        UIApplication.shared.openURL(URL(string: "http://www.excy.live/")!)
//        liveButtonString = "http://www.excy.live/"
//        performSegue(withIdentifier: "toWebView", sender: self)
    }

}
