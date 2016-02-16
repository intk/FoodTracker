//
//  VitrinesTableViewController.swift
//  ZMOnsite
//
//  Created by Andre Goncalves on 12/02/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class VitrinesTableViewController: UITableViewController {
    
    let cellIdentifier = "vitrineCellIdentifier"
    
    var vitrines = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadVitrines()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vitrines.count
    }
    
    func loadVitrines() {
        // Create Vitrines
        var vitrine1 = Dictionary<String,String>()
        vitrine1["name"] = "Wonderkamer Leven & Dood"
        
        /*var vitrine2 = Dictionary<String,String>()
        vitrine2["name"] = "Vitrine #2"
        
        var vitrine3 = Dictionary<String,String>()
        vitrine3["name"] = "Vitrine #3"
        
        var vitrine4 = Dictionary<String,String>()
        vitrine4["name"] = "Vitrine #4"*/
        
        vitrines += [vitrine1]
        
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("vitrineCellIdentifier", forIndexPath: indexPath)
        if let vitrine = vitrines[indexPath.row] as? [String: AnyObject], let name = vitrine["name"] as? String {
            cell.textLabel?.text = name
        }

        return cell
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
