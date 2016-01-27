//
//  MealCollectionViewController.swift
//  FoodTracker
//
//  Created by Andre Goncalves on 27/01/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import AVFoundation

class MealCollectionViewController: UICollectionViewController {
    
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Load any saved meals, otherwise load sample data.
        /*if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            // Load the sample data.
            loadSampleMeals()
        }*/
        loadSampleMeals()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
    }
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")!
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "meal2")!
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "meal3")!
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        let photo4 = UIImage(named: "meal4")!
        let meal4 = Meal(name: "Caprese Salad", photo: photo4, rating: 4)!
        
        let photo5 = UIImage(named: "meal5")!
        let meal5 = Meal(name: "Chicken and Potatoes", photo: photo5, rating: 5)!
        
        let photo6 = UIImage(named: "meal6")!
        let meal6 = Meal(name: "Pasta with Meatballs", photo: photo6, rating: 3)!
        
        let photo7 = UIImage(named: "meal7")!
        let meal7 = Meal(name: "Chicken and Potatoes", photo: photo7, rating: 5)!
        
        let photo8 = UIImage(named: "meal9")!
        let meal8 = Meal(name: "Pasta with Meatballs", photo: photo8, rating: 3)!
        
        let photo9 = UIImage(named: "meal10")!
        let meal9 = Meal(name: "Chicken and Potatoes", photo: photo9, rating: 5)!
        
        let photo10 = UIImage(named: "meal11")!
        let meal10 = Meal(name: "Pasta with Meatballs", photo: photo10, rating: 3)!
        
        let photo11 = UIImage(named: "meal12")!
        let meal11 = Meal(name: "Pasta with Meatballs", photo: photo11, rating: 3)!
        
        let photo12 = UIImage(named: "meal13")!
        let meal12 = Meal(name: "Chicken and Potatoes", photo: photo12, rating: 5)!
        
        let photo13 = UIImage(named: "meal14")!
        let meal13 = Meal(name: "Pasta with Meatballs", photo: photo13, rating: 3)!
        
        let photo14 = UIImage(named: "meal15")!
        let meal14 = Meal(name: "Pasta with Meatballs", photo: photo14, rating: 3)!
        
        let photo15 = UIImage(named: "meal16")!
        let meal15 = Meal(name: "Chicken and Potatoes", photo: photo15, rating: 5)!
        
        let photo16 = UIImage(named: "meal17")!
        let meal16 = Meal(name: "Pasta with Meatballs", photo: photo16, rating: 3)!
        
        meals += [meal1, meal2, meal3, meal4, meal5, meal6, meal7, meal8, meal9, meal10, meal11, meal12, meal13, meal14, meal15, meal16]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the cell that generated this segue.
        if segue.identifier == "showDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            if let selectedMealCell = sender as? AnnotatedPhotoCell {
                let indexPath = collectionView!.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }
    
    @IBAction func unwindToMealCollectionList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            let selectedIndexPath = collectionView?.indexPathsForSelectedItems()
            if (selectedIndexPath!.count > 0) {
                // Update an existing meal.
                meals[selectedIndexPath![0].row] = meal
                collectionView?.reloadItemsAtIndexPaths([selectedIndexPath![0]])
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                collectionView?.insertItemsAtIndexPaths([newIndexPath])
            }
            // Save the meals.
            saveMeals()
        }
    }
    

    func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }

}

extension MealCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        cell.photo = meals[indexPath.item]
        return cell
    }
    
}

extension MealCollectionViewController : PinterestLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, widthForPhotoAtIndexPath indexPath: NSIndexPath,
        withHeight width: CGFloat) -> CGFloat {
            let photo = meals[indexPath.item]
            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo.photo!.size, boundingRect)
            return rect.size.height
    }
    
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth height: CGFloat) -> CGFloat {
            let photo = meals[indexPath.item]
            let boundingRect =  CGRect(x: 0, y: 0, width: CGFloat(MAXFLOAT), height: height)
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo.photo!.size, boundingRect)
            return rect.size.width
    }
    
    // 2
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            return CGFloat(0.0)
    }
}

