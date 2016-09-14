//
//  WorkoutsHistory.swift
//  ExCy
//
//  Created by Luke Regan on 7/21/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import Foundation

struct StringFromDate {
	static func stringFromDate(date: NSDate) -> String {
		let date = date
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE hh:mm a"
		return dateFormatter.stringFromDate(date)
	}
	static func startStringFromDate(date: NSDate) -> String {
		let date = date
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMM d yyyy"
		return dateFormatter.stringFromDate(date)
	}
}

class Workout {

	var dateCompleted: String
	var timeAsString: String
	var workoutTitle: String
	var caloriesBurned: Double
	
	var location: String = "at work"
	var enjoyment: String = "great"
	var minTemp: Int
	var maxTemp: Int
	var uid: String!
	
	init(workoutTitle: String, time: Int, uid: String, minTemp: Int = 0, maxTemp: Int = 0){
		self.workoutTitle = workoutTitle
		self.timeAsString = StringConversion.timeStringFromSeconds(time)
		self.caloriesBurned = (Double(time) / 60) * 13
		self.minTemp = minTemp
		self.maxTemp = maxTemp
		
		// Date
		let date = NSDate()
		self.dateCompleted = StringFromDate.stringFromDate(date)
		self.uid = uid
	}
	
	
	func addLocationAndEnjoyment(location: String, enjoyment: String){
		self.enjoyment = enjoyment
		self.location = location
	}
	
	
	init(dictionary: [String: AnyObject]) {
		if let workoutTitle = dictionary["workoutTitle"] as? String { self.workoutTitle = workoutTitle } else {
			self.workoutTitle = ""
		}
		if let totalTime = dictionary["totalTime"] as? String { self.timeAsString = totalTime } else {
			self.timeAsString = ""
		}
		if let caloriesBurned = dictionary["caloriesBurned"] as? Double { self.caloriesBurned = caloriesBurned } else {
			self.caloriesBurned = 0.0
		}
		if let dateCompleted = dictionary["dateCompleted"] as? String { self.dateCompleted = dateCompleted } else {
			self.dateCompleted = ""
		}
		if let enjoyment = dictionary["enjoyment"] as? String { self.enjoyment = enjoyment } else {
			self.enjoyment = ""
		}
		if let location = dictionary["location"] as? String { self.location = location } else {
			self.location = ""
		}
		if let minTemp = dictionary["minTemp"] as? Int { self.minTemp = minTemp } else {
			self.minTemp = 0
		}
		if let maxTemp = dictionary["maxTemp"] as? Int { self.maxTemp = maxTemp } else {
			self.maxTemp = 0
		}
	
	}
	

	func convertToDictionaryWithoutSurvey() -> [String: AnyObject] {
		return [
			"uid": self.uid,
			"workoutTitle": self.workoutTitle,
			"totalTime": self.timeAsString,
			"caloriesBurned": self.caloriesBurned,
			"dateCompleted": self.dateCompleted,
			"minTemp": self.minTemp,
			"maxTemp": self.maxTemp
		]
	}
	func convertToDictionarySurvey() -> [String: AnyObject] {
		return [
			"uid": self.uid,
			"workoutTitle": self.workoutTitle,
			"totalTime": self.timeAsString,
			"caloriesBurned": self.caloriesBurned,
			"dateCompleted": self.dateCompleted,
			"minTemp": self.minTemp,
			"maxTemp": self.maxTemp,
			"enjoyment": self.enjoyment,
			"location":self.location,
		]
	}
	
	
	
	func workoutEnjoyment(number: Int) -> String {
		switch number {
		case 1: return "awful"
		case 2: return "bad"
		case 3: return "good"
		case 4: return "great"
		case 5: return "amazing"
		default: return "good"
		}
	}
	func workoutLocation(number: Int) -> String {
		switch number {
		case 1: return "at home"
		case 2: return "at home"
		case 3: return "at work"
		case 4: return "traveling"
		case 5: return "on the go"
		default: return "good"
		}
	}
	
	
}