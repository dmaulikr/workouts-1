//
//  ProgressView.swift
//  ExCy
//
//  Created by Luke Regan on 9/10/15.
//  Copyright (c) 2015 LukeRegan. All rights reserved.
//

import UIKit

class ProgressView: UIView {
	
	var progress: CGFloat =  0.01

	override func drawRect(rect: CGRect) {
		StyleKitName.drawCanvas1(progressAmmount: progress)
    }

}



class WorkoutProgressView: UIView {
	
	var progress: CGFloat =  0.001
	
	override func drawRect(rect: CGRect) {
		workoutsProgressOverlay.drawCanvas1(progressAmmount: progress)
	}
	
}
