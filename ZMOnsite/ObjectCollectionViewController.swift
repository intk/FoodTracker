//
//  ObjectCollectionViewController.swift
//  FoodTracker
//
//  Created by Andre Goncalves on 27/01/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ObjectCollectionViewController: UICollectionViewController {
    
    var objects = [Object]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Load any saved Objects, otherwise load sample data.
        /*if let savedObjects = loadObjects() {
            Objects += savedObjects
        } else {
            // Load the sample data.
            loadSampleObjects()
        }*/
        loadSampleObjects()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.collectionView!.reloadData()
    }
    
    func loadSampleObjects() {
        
        let photo1 = UIImage(named: "Object1")!
        let Object1 = Object(name: "Dekselbokaal met radgravure, inscriptie: HANSIE IN DE KELDER (glas) Duitsland of Nederland, 1725-1750", photo: photo1, objectNumber:"AB1694-01/02", description:"", story:"In de achttiende eeuw nam de belangstelling voor diamantgegraveerde glazen af ten gunste van radgegraveerde en geslepen glazen. De techniek is heel anders dan die van de diamantgravure; door met een diamant in een graveerstift op glas te krassen, ontstaat contrast tussen licht (gekraste delen) en donker (gladde delen). Bij de radgravure wordt de tekening aangebracht door het glas te drukken tegen snel roterende radertjes, die met de voet in beweging worden gebracht. Men heeft het glas hierbij met beide handen vast. Bij deze techniek is het mogelijk verschillende dieptes in te slijpen en te variëren met een keuze aan wieltjes. Ook kan men het mat geslepen oppervlak weer gedeeltelijk glad polijsten. Letters worden meestal in hoofdletters uitgevoerd. De techniek werd rond het midden van de zeventiende eeuw vanuit Neurenberg naar de Nederlanden overgebracht. Vooral in de achttiende eeuw was het zeer populair. Meestal werd hierbij gebruik gemaakt van geïmporteerde Engelse kelken van sprankelend helder loodglas of Duitse glazen van krijtglas. De voorstellingen variëren van vriendschaps- en huwelijksglazen tot glazen met betrekking tot de kraamtijd. Het krijgen van kinderen om het nageslacht te waarborgen was het belangrijkste doel van het huwelijk in de zeventiende en achttiende eeuw. De voorstellingen op glazen verwijzen hiernaar. Zo verwijst 'Hansje in de kelder' naar de zwangerschap. 'Hansje' was synoniem voor de ongebore", location:"")!
        
        let photo3 = UIImage(named: "Object3")!
        let Object3 = Object(name: "Wonderkamer Leven & Dood", photo: photo3, objectNumber:"B191-64", description:"Jurk (leer, glas, wol, koper, ijzer) Siksika/Zwartvoet Indianen, Canada, 1875-1890", story:"Zwartvoet Indianen zijn van oorsprong jagers. Voor hun kleding en gebruiksvoorwerpen maken ze gebruik van materialen die voorhanden zijn. Deze jurk is gemaakt van leer. Het is een kledingstuk voor dagelijks gebruik. De jurk is versierd met kralen, franjes en belletjes. Oorspronkelijk is de jurk waarschijnlijk ook met hermelijnbont gedecoreerd geweest, maar hiervan zijn geen resten meer over. Met de komst van Europese kolonisten komt vanaf de 19e eeuw ook westerse kleding beschikbaar voor de Zwartvoet. De traditionele leren kleding wordt sindsdien vooral nog op bijzondere gelegenheden gedragen.", location:"Wonderkamer - Indianen")!
        
        let photo2 = UIImage(named: "Object2")!
        let Object2 = Object(name: "Pasta with Meatballs", photo: photo2, objectNumber:"", description:"", story:"", location:"")!
        
        let photo4 = UIImage(named: "Object4")!
        let Object4 = Object(name: "Caprese Salad", photo: photo4, objectNumber:"", description:"", story:"", location:"")!
        
        let photo5 = UIImage(named: "Object5")!
        let Object5 = Object(name: "Chicken and Potatoes", photo: photo5, objectNumber:"", description:"", story:"", location:"")!
        
        let photo6 = UIImage(named: "Object6")!
        let Object6 = Object(name: "Pasta with Meatballs", photo: photo6, objectNumber:"", description:"", story:"", location:"")!
        
        let photo7 = UIImage(named: "Object7")!
        let Object7 = Object(name: "Chicken and Potatoes", photo: photo7, objectNumber:"", description:"", story:"", location:"")!
        
        let photo8 = UIImage(named: "Object9")!
        let Object8 = Object(name: "Pasta with Meatballs", photo: photo8, objectNumber:"", description:"", story:"", location:"")!
        
        let photo9 = UIImage(named: "Object10")!
        let Object9 = Object(name: "Chicken and Potatoes", photo: photo9, objectNumber:"", description:"", story:"", location:"")!
        
        let photo10 = UIImage(named: "Object11")!
        let Object10 = Object(name: "Pasta with Meatballs", photo: photo10, objectNumber:"", description:"", story:"", location:"")!
        
        let photo11 = UIImage(named: "Object12")!
        let Object11 = Object(name: "Pasta with Meatballs", photo: photo11, objectNumber:"", description:"", story:"", location:"")!
        
        let photo12 = UIImage(named: "Object13")!
        let Object12 = Object(name: "Chicken and Potatoes", photo: photo12, objectNumber:"", description:"", story:"", location:"")!
        
        let photo13 = UIImage(named: "Object14")!
        let Object13 = Object(name: "Pasta with Meatballs", photo: photo13, objectNumber:"", description:"", story:"", location:"")!
        
        let photo14 = UIImage(named: "Object15")!
        let Object14 = Object(name: "Pasta with Meatballs", photo: photo14, objectNumber:"", description:"", story:"", location:"")!
        
        let photo15 = UIImage(named: "Object16")!
        let Object15 = Object(name: "Chicken and Potatoes", photo: photo15, objectNumber:"", description:"", story:"", location:"")!
        
        let photo16 = UIImage(named: "Object17")!
        let Object16 = Object(name: "Pasta with Meatballs", photo: photo16, objectNumber:"", description:"", story:"", location:"")!
        
        objects += [Object1, Object2, Object3, Object4, Object5, Object6, Object7, Object8, Object9, Object10, Object11, Object12, Object13, Object14, Object15, Object16]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the cell that generated this segue.
        if segue.identifier == "showDetail" {
            let ObjectDetailViewController = segue.destinationViewController as! ObjectViewController
            if let selectedObjectCell = sender as? AnnotatedPhotoCell {
                let indexPath = collectionView!.indexPathForCell(selectedObjectCell)!
                let selectedObject = objects[indexPath.row]
                ObjectDetailViewController.object = selectedObject
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new Object.")
        }
    }
    
    @IBAction func unwindToObjectCollectionList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ObjectViewController, Object = sourceViewController.object {
            let selectedIndexPath = collectionView?.indexPathsForSelectedItems()
            if (selectedIndexPath!.count > 0) {
                // Update an existing Object.
                objects[selectedIndexPath![0].row] = Object
                collectionView?.reloadData()
            } else {
                // Add a new Object.
                let newIndexPath = NSIndexPath(forRow: objects.count, inSection: 0)
                objects.append(Object)
                collectionView?.insertItemsAtIndexPaths([newIndexPath])
            }
            // Save the Objects.
            saveObjects()
        }
    }
    

    func saveObjects() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(objects, toFile: Object.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save Objects...")
        }
    }
    
    func loadObjects() -> [Object]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Object.ArchiveURL.path!) as? [Object]
    }

}

extension ObjectCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        cell.photo = objects[indexPath.item]
        return cell
    }
    
}

extension ObjectCollectionViewController : PinterestLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, widthForPhotoAtIndexPath indexPath: NSIndexPath,
        withHeight width: CGFloat) -> CGFloat {
            let photo = objects[indexPath.item]
            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo.photo!.size, boundingRect)
            return rect.size.height
    }
    
    // 1
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            if UIDevice.currentDevice().orientation == .Portrait {
                let photo = objects[indexPath.item]
                let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
                let rect  = AVMakeRectWithAspectRatioInsideRect(photo.photo!.size, boundingRect)
                return rect.size.height
            } else {
                let photo = objects[indexPath.item]
                let boundingRect =  CGRect(x: 0, y: 0, width: CGFloat(MAXFLOAT), height: width)
                let rect  = AVMakeRectWithAspectRatioInsideRect(photo.photo!.size, boundingRect)
                return rect.size.width
            }
    }
    
    // 2
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            return CGFloat(0.0)
    }
}

