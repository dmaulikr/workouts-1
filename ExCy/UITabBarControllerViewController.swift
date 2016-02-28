//
//  UITabBarControllerViewController.swift
//  ExCy
//
//  Created by Luke Regan on 2/2/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

class UITabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		tabBarUISetUP()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func tabBarUISetUP() {
		for item in self.tabBar.items! {
			if let image = item.image {
				item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
			}
		}
		let navigationBarAppearance = UITabBar.appearance()
		let navItemAppearance = UITabBarItem.appearance()
		
		let selectedTintColor = UIColor(red: 19/255, green: 183/255, blue: 230/255, alpha: 1)
		let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
		
		navigationBarAppearance.barTintColor = UIColor(red: 111/255, green: 110/255, blue: 109/255, alpha: 1)
		navigationBarAppearance.tintColor = selectedTintColor
		
		navItemAppearance.setTitleTextAttributes ([NSForegroundColorAttributeName : selectedTintColor], forState: UIControlState.Selected)
		navItemAppearance.setTitleTextAttributes ([NSForegroundColorAttributeName : whiteColor], forState: UIControlState.Normal)
		
	}

}

extension UIImage {
	func imageWithColor(tintColor: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		
		let context = UIGraphicsGetCurrentContext() //as CGContextRef
		CGContextTranslateCTM(context, 0, self.size.height)
		CGContextScaleCTM(context, 1.0, -1.0);
		CGContextSetBlendMode(context, .Normal)
		
		let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
		CGContextClipToMask(context, rect, self.CGImage)
		tintColor.setFill()
		CGContextFillRect(context, rect)
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
		UIGraphicsEndImageContext()
		
		return newImage
	}
}

