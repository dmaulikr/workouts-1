//
//  DataService.swift
//  ExCy
//
//  Created by Luke Regan on 3/1/16.
//  Copyright © 2016 LukeRegan. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://excy.firebaseio.com"

class DataSerice {
	
	static let ds = DataSerice()
	
	private var _REF_BASE = Firebase(url: "\(URL_BASE)")
	private var _REF_WORKOUTS = Firebase(url: "\(URL_BASE)/workouts")
	private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
	
	var REF_BASE: Firebase { return _REF_BASE }
	var REF_WORKOUTS: Firebase { return _REF_WORKOUTS }
	var REF_USERS: Firebase { return _REF_USERS }
	
	func createFirebaseUser(uid: String, user: [String: AnyObject]) {
		REF_USERS.childByAppendingPath(uid).setValue(user)
	}
	
}