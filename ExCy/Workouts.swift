//
//  WorkoutsHistory.swift
//  ExCy
//
//  Created by Luke Regan on 7/21/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import Foundation

class Workouts {
	
	var stringConverter = StringConversion()
	
	var dateCompleted: String
	var totalTime: Int
	var timeAsString: String
	var workoutTitle: String
	var caloriesBurned: Double
	
	var locationAsInt: Int = 3
	var location: String!
	var enjoymentAsInt: Int = 4
	var enjoyment: String!
	
	init(workoutTitle: String, time: Int){
		
		self.workoutTitle = workoutTitle
		self.totalTime = time
		self.timeAsString = stringConverter.timeStringFromSeconds(time)
		self.caloriesBurned = (Double(time) / 60) * 18
		
		// Date
		let date = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE hh:mm a"
		
		self.dateCompleted = dateFormatter.stringFromDate(date)
		
		self.enjoyment = self.workoutEnjoyment(self.enjoymentAsInt)
		self.location = self.workoutLocation(self.locationAsInt)
	}
	
	init(workoutTitle: String, time: Int, location: Int, enjoyment: Int){
		self.workoutTitle = workoutTitle
		self.totalTime = time
		self.timeAsString = stringConverter.timeStringFromSeconds(time)
		self.caloriesBurned = (Double(time) / 60) * 18
		
		// Date
		let date = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE hh:mm a"
		
		self.dateCompleted = dateFormatter.stringFromDate(date)
		
		self.enjoyment = self.workoutEnjoyment(location)
		self.location = self.workoutLocation(enjoyment)
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