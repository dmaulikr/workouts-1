//
//  DataService.swift
//  ExCy
//
//  Created by Luke Regan on 3/1/16.
//  Copyright © 2016 LukeRegan. All rights reserved.
//

import Foundation
import Firebase

//let URL_BASE = "https://excy.firebaseio.com"

class DataSerice {
	
	static let ds = DataSerice()
    
    fileprivate var _REF_WORKOUTS = FIRDatabase.database().reference(withPath:"workouts")
	fileprivate var _REF_USERS = FIRDatabase.database().reference(withPath:"users")
	
	var REF_WORKOUTS: FIRDatabaseReference { return _REF_WORKOUTS }
	var REF_USERS: FIRDatabaseReference { return _REF_USERS }
	
	func createFirebaseUser(_ uid: String, user: [String: Any]) {
        REF_USERS.child(uid).setValue(user)
	}
	
}
