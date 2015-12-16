//
//  HistoryTableViewController.swift
//  ExCy
//
//  Created by Luke Regan on 9/29/15.
//  Copyright © 2015 LukeRegan. All rights reserved.
//

import UIKit
import Parse

class HistoryTableViewController: UITableViewController {
	
	var workoutsObject: NSMutableArray! = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		_ = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "delayedViewUpdate", userInfo: nil, repeats: false)
		self.tableView.reloadData()
		fetchAllObjects()
		fetchAllObjectsFromLocalDataStore()
	}
	func delayedViewUpdate() {
		self.tableView.reloadData()
	}
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if self.workoutsObject.count > 20 {
			return 20
		} else {
			return self.workoutsObject.count
		}
    }
	
	func fetchAllObjectsFromLocalDataStore() {
		let query: PFQuery = PFQuery(className: "Workout")
		query.fromLocalDatastore()
		query.whereKey("username", equalTo: (PFUser.currentUser()!.username)!)
		query.addDescendingOrder("createdAt")
		query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
			if (error == nil) {
				let temp: NSArray = objects! as NSArray
				self.workoutsObject = temp.mutableCopy() as! NSMutableArray
				self.tableView.reloadData()
			} else {
				print(error!.userInfo)
			}
		}
	}
	func fetchAllObjects() {
		PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
		let query: PFQuery = PFQuery(className: "Workout")
		query.whereKey("username", equalTo: (PFUser.currentUser()!.username)!)
		query.addDescendingOrder("createdAt")
		query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
			if (error == nil) {
				PFObject.pinAllInBackground(objects, block: nil)
			} else {
				print(error!.userInfo)
			}
		}
	}
	

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoryTableViewCell

		let object: PFObject = self.workoutsObject.objectAtIndex(indexPath.row) as! PFObject
		
		cell.workoutTitleLabel.text = object["title"] as? String
		cell.totalTimeLabel.text = object["timeWorkedOut"] as? String
		cell.caloriesBurnedLabel.text = String(object["caloriesBurned"] as! Int)
		cell.dateCompletedLabel.text = object["date"] as? String
		cell.enjoymentLabel.text = object["enjoyment"] as? String
		if let minTemp = object["minTemp"] as? Int {
			if let maxTemp = object["maxTemp"] as? Int {
				cell.zoneIntensityLabel.text = "min:\(minTemp)\n max:\(maxTemp)" } }
		cell.locationLabel.text = object["location"] as? String
		cell.enjoymentImageView.image = workoutEnjoyment(object["enjoyment"] as! String)
		cell.locationImageView.image = workoutLocation(object["location"] as! String)

        return cell
    }
	
	func workoutEnjoyment(enjoyment: String) -> UIImage {
		switch enjoyment {
		case "awful": return UIImage(named: "SmilieIcons_sad.png")!
		case "bad": return UIImage(named: "SmilieIcons_sad.png")!
		case "good": return UIImage(named: "SmilieIcons_satisfied.png")!
		case "great": return UIImage(named: "SmilieIcons_happy.png")!
		case "amazing": return UIImage(named: "SmilieIcons_happy.png")!
		default: return UIImage(named: "SmilieIcons_happy.png")!
		}
	}
	func workoutLocation(location: String) -> UIImage {
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
