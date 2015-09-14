//
//  WorkoutsHistory.swift
//  ExCy
//
//  Created by Luke Regan on 7/21/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import Foundation

class Workouts: NSObject, NSCoding {
	
	var dateCompleted: String
	var totalTime: String
	var workoutTitle: String
	
	
	init(workoutTitle: String, time: String){
		self.workoutTitle = workoutTitle
		self.totalTime = time
		
		// Date
		let date = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE hh:mm a"
		
		self.dateCompleted = dateFormatter.stringFromDate(date)
	}
	
	required init(coder aDecoder: NSCoder) {
		dateCompleted = aDecoder.decodeObjectForKey("dateCompleted") as! String
		totalTime = aDecoder.decodeObjectForKey("totalTime") as! String
		workoutTitle = aDecoder.decodeObjectForKey("workoutTitle") as! String
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(dateCompleted, forKey:"dateCompleted")
		aCoder.encodeObject(totalTime, forKey: "totalTime")
		aCoder.encodeObject(workoutTitle, forKey: "workoutTitle")
	}
	
}