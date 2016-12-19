//
//  HistoryTableViewCell.swift
//  ExCy
//
//  Created by Luke Regan on 9/29/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

	@IBOutlet weak var workoutTitleLabel: UILabel!
	@IBOutlet weak var dateCompletedLabel: UILabel!
	@IBOutlet weak var totalTimeLabel: UILabel!
	@IBOutlet weak var zoneIntensityLabel: UILabel!
	@IBOutlet weak var caloriesBurnedLabel: UILabel!
	@IBOutlet weak var enjoymentLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var enjoymentImageView: UIImageView!
	@IBOutlet weak var locationImageView: UIImageView!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
