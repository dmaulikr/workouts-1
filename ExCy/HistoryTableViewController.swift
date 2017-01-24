//
//  HistoryTableViewController.swift
//  ExCy
//
//  Created by Luke Regan on 9/29/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse
import Firebase

class HistoryTableViewController: UITableViewController {
	
	let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
	
	var workoutsObject = [Workout]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		DataSerice.ds.REF_WORKOUTS.child(uid).queryLimited(toLast: 5).observe(.value, with: { snapshot in
			if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
				for snap in snapshots {
					if let workoutDict = snap.value as? [String: AnyObject] {
						let workout = Workout(dictionary: workoutDict)
						self.workoutsObject.insert(workout, at: 0)
						
					}
				}
			}
			self.tableView.reloadData()
		})

		
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.tableView.reloadData()
	}
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if self.workoutsObject.count > 20 {
			return 20
		} else {
			return self.workoutsObject.count
		}
    }
	

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell

		let workout = self.workoutsObject[indexPath.row]
		print(workout)
		
		cell.workoutTitleLabel.text = workout.workoutTitle
		cell.totalTimeLabel.text = workout.timeAsString
		cell.caloriesBurnedLabel.text = "\(workout.caloriesBurned)"
		cell.dateCompletedLabel.text = workout.dateCompleted
		cell.enjoymentLabel.text = workout.enjoyment
		cell.zoneIntensityLabel.text = "min:\(workout.minTemp)\n max:\(workout.maxTemp)"
		cell.locationLabel.text = workout.location
		cell.enjoymentImageView.image = workoutEnjoyment(workout.enjoyment)
		cell.locationImageView.image = workoutLocation(workout.location)

        return cell
    }
	
	func workoutEnjoyment(_ enjoyment: String) -> UIImage {
		switch enjoyment {
		case "awful": return UIImage(named: "SmilieIcons_sad.png")!
		case "bad": return UIImage(named: "SmilieIcons_sad.png")!
		case "good": return UIImage(named: "SmilieIcons_satisfied.png")!
		case "great": return UIImage(named: "SmilieIcons_happy.png")!
		case "amazing": return UIImage(named: "SmilieIcons_happy.png")!
		default: return UIImage(named: "SmilieIcons_happy.png")!
		}
	}
	func workoutLocation(_ location: String) -> UIImage {
		switch location {
		case "at home": return UIImage(named: "Account_Home.png")!
		case "at work": return UIImage(named: "Account_Work.png")!
		case "traveling": return UIImage(named: "Account_Traveling.png")!
		case "on the go": return UIImage(named: "Account_Onthego.png")!
		default: return UIImage(named: "Account_Home.png")!
		}
	}


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
