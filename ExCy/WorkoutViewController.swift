//
//  WorkoutViewController.swift
//  ExCy
//
//  Created by Luke Regan on 10/4/14.
//  Copyright (c) 2014 LukeRegan. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	@IBOutlet weak var workoutPickerView: UIPickerView!
	@IBOutlet weak var calorieTextField: UITextField!
	@IBOutlet weak var calorieSliderOutlet: UISlider!
	
	var workoutSelection:NSArray = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		workoutSelection = ["Arm Cycle", "Chair Cycle", "Floor Cycle"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return workoutSelection.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		return "\(workoutSelection[row])"
	}
    
	@IBAction func calorieSlider(sender: UISlider) {
		self.calorieTextField.text = "\(Int(self.calorieSliderOutlet.value))"
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
