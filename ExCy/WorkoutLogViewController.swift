//
//  WorkoutLogViewController.swift
//  ExCy
//
//  Created by Luke Regan on 10/4/14.
//  Copyright (c) 2014 LukeRegan. All rights reserved.
//

import UIKit

class WorkoutLogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	@IBOutlet weak var sortByPicker: UIPickerView!
	
	var sortBySelection:NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		sortBySelection = ["Most recent", "Duration", "Calories", "Intensity"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return sortBySelection.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		return "\(sortBySelection[row])"
	}
	
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
