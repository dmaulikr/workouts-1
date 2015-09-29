//
//  File.swift
//  ExCy
//
//  Created by Luke Regan on 9/29/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import Foundation
import Parse

class ParseWorkout {
	
	var stringConverter = StringConversion()
    var workout = PFObject(className: "Workout")
	
	init(title: String, time: Int){
		workout["title"] = title
		workout["timeWorkedOut"] = stringConverter.timeStringFromSeconds(time)
		workout["caloriesBurned"] = (Double(time) / 60) * 18
		workout["enjoyment"] = "default"
		workout["location"] = "default"
		workout.saveInBackgroundWithBlock { (success, error) -> Void in
			if error != nil { return }
			
		}
		
	}
	
	init(title: String, time: Int, enjoyment: Int, location: Int){
		workout["title"] = title
		workout["timeWorkedOut"] = stringConverter.timeStringFromSeconds(time)
		workout["caloriesBurned"] = (Double(time) / 60) * 18
		workout["enjoyment"] = workoutEnjoyment(enjoyment)
		workout["location"] = workoutLocation(location)
		workout.saveInBackgroundWithBlock { (success, error) -> Void in
			if error != nil { return }
			
		}
		
	}
	
	func workoutEnjoyment(number: Int) -> String {
		switch number {
		case 1: return "awful"
		case 2: return "bad"
		case 3: return "good"
		case 4: return "great"
		case 5: return "amazing"
		default: return "default"
		}
	}
	func workoutLocation(number: Int) -> String {
		switch number {
		case 1: return "at home"
		case 2: return "at home"
		case 3: return "at work"
		case 4: return "traveling"
		case 5: return "on the go"
		default: return "default"
		}
	}
	
}