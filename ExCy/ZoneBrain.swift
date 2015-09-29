//
//  IntervalSwitching.swift
//  ExCy
//
//  Created by Luke Regan on 9/28/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import Foundation

class ZoneBrain {
	
	let totalWorkoutTime: Int
	let numberOfZones: Int
	let zoneChangeInSeconds: Int
	
	init(time: Int, zones: Int){
		self.totalWorkoutTime = time
		self.numberOfZones = zones
		self.zoneChangeInSeconds = time / zones
	}
	
	func getZoneArray() -> [Int] {
		switch self.numberOfZones {
			case 7: return [3,5,3,5,3,5,3]
			case 10: return [3,5,3,5,3,5,3,5,3,5]
			case 12: return [3,3,4,5,3,4,5,3,4,5,3,4]
			case 23: return [2,3,3,4,4,5,5,3,3,5,5,3,3,5,5,3,3,4,4,5,5,4,3]
			default: return [3,5,3,5,3,5,3]
		}
	}
	
}