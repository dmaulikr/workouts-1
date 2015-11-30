//
//  VideosAndTipsViewController.swift
//  ExCy
//
//  Created by Luke Regan on 11/29/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import UIKit

class VideosAndTipsViewController: UIViewController {

	@IBOutlet weak var webView: UIWebView!
	var youtubeURL: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let youtubeString = youtubeURL {
			webView.loadHTMLString(youtubeString, baseURL: nil)
		} else {
			webView.loadHTMLString("<iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height / 2)\" src=\"https://www.youtube.com/embed/0eONwwRUIJc\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
		}

		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
