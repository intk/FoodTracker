//
//  ObjectTableViewController.swift
//  FoodTracker
//
//  Created by André Gonçalves on 19/01/15.
//  Copyright © 2016 INTK. All rights reserved.
//

import UIKit

class ObjectTableViewController: UITableViewController {
    // MARK: Properties
    
    var Objects = [Object]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved Objects, otherwise load sample data.
        if let savedObjects = loadObjects() {
            Objects += savedObjects
        } else {
            // Load the sample data.
            loadSampleObjects()
        }
    }
    
    func loadSampleObjects() {
        let photo1 = UIImage(named: "Object1")!
        let Object1 = Object(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "Object2")!
        let Object2 = Object(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "Object3")!
        let Object3 = Object(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        Objects += [Object1, Object2, Object3]
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
        return Objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ObjectTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate Object for the data source layout.
        let Object = Objects[indexPath.row]
        
        cell.nameLabel.text = Object.name
        cell.photoImageView.image = Object.photo
        cell.ratingControl.rating = Object.rating
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            Objects.removeAtIndex(indexPath.row)
            saveObjects()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let ObjectDetailViewController = segue.destinationViewController as! ObjectViewController
            
            // Get the cell that generated this segue.
            if let selectedObjectCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedObjectCell)!
                let selectedObject = Objects[indexPath.row]
                ObjectDetailViewController.object = selectedObject
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new Object.")
        }
    }
    

    @IBAction func unwindToObjectList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ObjectViewController, Object = sourceViewController.object {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing Object.
                Objects[selectedIndexPath.row] = Object
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new Object.
                let newIndexPath = NSIndexPath(forRow: Objects.count, inSection: 0)
                Objects.append(Object)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the Objects.
            saveObjects()
        }
    }
    
    // MARK: NSCoding
    
    func saveObjects() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Objects, toFile: Object.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save Objects...")
        }
    }
    
    func loadObjects() -> [Object]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Object.ArchiveURL.path!) as? [Object]
    }
}
