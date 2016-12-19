//
//  StringConversion.swift
//  ExCy
//
//  Created by Luke Regan on 9/28/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

class StringConversion {
	
	class func timeStringFromSeconds(_ seconds:Int) -> String {
		let minutesCount = seconds / 60
		let secondsCount = seconds - (minutesCount * 60)
		var minuteString = String(minutesCount)
		var secondString = String(secondsCount)
		if secondsCount < 10 { secondString = "0\(secondsCount)"}
		else { secondString = "\(secondsCount)" }
		if minutesCount < 10 { minuteString = "0\(minutesCount)"}
		else { minuteString = "\(minutesCount)" }
		return "\(minuteString):\(secondString)"
	}
}
