//
//  CategoriesCollectionViewController.swift
//  ZMOnsite
//
//  Created by Andre Goncalves on 16/02/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "CategoriesImageCellId"

class CategoriesCollectionViewController: UICollectionViewController {
    
    var categories = [Object]()
    var backButton: UIBarButtonItem!
    
    @IBOutlet weak var languageBtn: UIBarButtonItem!
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "languageDidChangeNotification:", name: "LANGUAGE_DID_CHANGE", object: nil)
        
        loadCategories()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        checkLanguage()
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    func loadCategories() {
        let photoName = "categoryPhoto"
        let categoryPhoto = UIImage(named: photoName)!
        
        let obj = Object(name: "Wonderkamer Leven & Dood", photo: categoryPhoto, objectNumber:"", description:"", story:"", location:"", syncDate:"", imageURL: "", title_translation: "", objectDescription_translation:"", location_translation:"", story_translation:"")!
        
        categories += [obj]
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.collectionView!.reloadData()
    }
    
    @IBAction func clickLanguageBtn(sender: AnyObject) {
        let selectedLanguage = NSUserDefaults.standardUserDefaults().valueForKey("selectedLanguage") as? String
        
        if selectedLanguage == "nl" {
            NSUserDefaults.standardUserDefaults().setObject("en", forKey: "selectedLanguage")
            NSNotificationCenter.defaultCenter().postNotificationName("LANGUAGE_WILL_CHANGE", object: "en")
        } else {
            NSUserDefaults.standardUserDefaults().setObject("nl", forKey: "selectedLanguage")
            NSNotificationCenter.defaultCenter().postNotificationName("LANGUAGE_WILL_CHANGE", object: "nl")
        }
    }
    
    func languageDidChangeNotification(notification:NSNotification) {
        print("[Categories] Language did change")
        let language = NSUserDefaults.standardUserDefaults().valueForKey("selectedLanguage") as? String
        print(language)
        if language == "nl" {
            languageBtn.title = "English"
        } else {
            languageBtn.title = "Dutch"
        }
        
        backButton = UIBarButtonItem(title: NSLocalizedString("back", comment:""), style: UIBarButtonItemStyle.Plain, target: nil, action:nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    func checkLanguage() {
        print("[Categories] check language")
        
        let preferredLanguage = NSLocale.preferredLanguages()[0] as String
        
        if preferredLanguage == "nl" {
            languageBtn.title = NSLocalizedString("English", comment:"")
            NSUserDefaults.standardUserDefaults().setValue("nl", forKey:"selectedLanguage")
        } else {
            languageBtn.title = NSLocalizedString("Dutch", comment:"")
            NSUserDefaults.standardUserDefaults().setValue("en", forKey:"selectedLanguage")
        }
    }

}

extension CategoriesCollectionViewController {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoriesImageCell
        
        cell.photo = categories[indexPath.item]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
}

extension CategoriesCollectionViewController : PinterestLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, widthForPhotoAtIndexPath indexPath: NSIndexPath,
        withHeight width: CGFloat) -> CGFloat {
            let photo = categories[indexPath.item]
            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo.photo!.size, boundingRect)
            return rect.size.height
    }
    
    // 1
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            if UIDevice.currentDevice().orientation == .Portrait {
                let photo = categories[indexPath.item]
                let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
                let rect  = AVMakeRectWithAspectRatioInsideRect(photo.photo!.size, boundingRect)
                return rect.size.height
            } else {
                let photo = categories[indexPath.item]
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

