//
//  ProgressView.swift
//  ExCy
//
//  Created by Luke Regan on 9/10/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

class ProgressView: UIView {
	
	var progress: CGFloat =  0.0

	override func draw(_ rect: CGRect) {
		StyleKitName.drawCanvas1(progress)
    }

}



class WorkoutProgressView: UIView {
	
	var progress: CGFloat =  0.0
	
	override func draw(_ rect: CGRect) {
		workoutsProgressOverlay.drawCanvas1(progress)
	}
	
}
