//
//  ObjectViewController.swift
//  FoodTracker
//
//  Created by André Gonçalves on 19/01/15.
//  Copyright © 2016 INTK. All rights reserved.
//

import UIKit
import AVFoundation

class ObjectViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    // Labels with values
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var objectNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    
    // Labels without content
    @IBOutlet weak var titleFieldLabel: UILabel!
    @IBOutlet weak var objectNumberFieldLabel: UILabel!
    @IBOutlet weak var descriptionFieldLabel: UILabel!
    @IBOutlet weak var locationFieldLabel: UILabel!
    @IBOutlet weak var storyFieldLabel: UILabel!
    
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var storyStackView: UIStackView!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var objectNumberStackView: UIStackView!
    @IBOutlet weak var titleStackView: UIStackView!
    
    @IBOutlet weak var languageBtn: UIBarButtonItem!
    
    // Container views
    @IBOutlet weak var fieldsStackView: UIStackView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var imageWrapperView: UIView!
    
    var currentHeight: CGFloat = 0.0
    var changeHeight: Bool = false
    
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /*
        This value is either passed by `ObjectTableViewController` in `prepareForSegue(_:sender:)`
        or constructed as part of adding a new Object.
    */
    var object: Object?
    var objectCollectionViewController: ObjectCollectionViewController?
    var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "languageDidChangeNotification:", name: "LANGUAGE_DID_CHANGE", object: nil)
        
        // Create Scroll View
        createScrollView()
        
        // Check language
        switchLanguage()

        // Set up views if editing an existing Object.
        if let object = object {
            photoImageView.image = object.photo
            showObjectFields(object)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //objectCollectionViewController?.handleRefresh((objectCollectionViewController?.refreshControl)!)
        switchLanguage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.changeHeight = true
        self.outerView.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        fixScrollableView()
  
        if !self.changeHeight {
            let height = heightForImage()
            self.imageHeight.constant = height
            self.currentHeight = height
        }
        
        self.changeHeight = true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        fixScrollableView()
        let height = heightForImage()
        UIView.animateWithDuration(Double(0.3), animations: {
            self.imageHeight.constant = height
            self.view.layoutIfNeeded()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //  This method lets you configure a view controller before it's presented.
    }
    
    //
    //  Language switcher
    //
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
        print("[Object] Language did change")
        let selectedLanguage = NSUserDefaults.standardUserDefaults().valueForKey("selectedLanguage") as? String
        fixAllTexts(selectedLanguage!)
        
        if let object = object {
            showObjectFields(object)
        }
        
        fixScrollableView()
    }
    
    func switchLanguage() {
        let selectedLanguage = NSUserDefaults.standardUserDefaults().valueForKey("selectedLanguage") as? String
        fixAllTexts(selectedLanguage!)
        if let object = object {
            showObjectFields(object)
        }
    }
    
    //
    //  Utils
    //
    
    func showObjectFields(object: Object) {
        let selectedLanguage = NSUserDefaults.standardUserDefaults().valueForKey("selectedLanguage") as? String

        if selectedLanguage != "nl" {
            // English
            descriptionLabel.text = object.objectDescription_translation
            nameLabel.text = object.title_translation
            navigationItem.title = object.title_translation
            objectNumberLabel.text = object.objectNumber
            storyLabel.text = object.story_translation
            locationLabel.text = object.location_translation
            
            if object.title_translation == "" {
                titleStackView.hidden = true
            } else {
                titleStackView.hidden = false
            }
            
            if object.objectDescription_translation == "" {
                descriptionStackView.hidden = true
            } else {
                descriptionStackView.hidden = false
            }
            
            if object.location_translation == "" {
                locationStackView.hidden = true
            } else {
                locationStackView.hidden = false
            }
            
            if object.story_translation == "" {
                storyStackView.hidden = true
            } else {
                storyStackView.hidden = false
            }
            
        } else {
            // Dutch
            descriptionLabel.text = object.objectDescription
            nameLabel.text = object.name
            navigationItem.title = object.name
            objectNumberLabel.text = object.objectNumber
            locationLabel.text = object.location
            storyLabel.text = object.story
            
            if object.name == "" {
                titleStackView.hidden = true
            } else {
                titleStackView.hidden = false
            }
            
            if object.objectDescription == "" {
                descriptionStackView.hidden = true
            } else {
                descriptionStackView.hidden = false
            }
            
            if object.location == "" {
                locationStackView.hidden = true
            } else {
                locationStackView.hidden = false
            }
            
            if object.story == "" {
                storyStackView.hidden = true
            } else {
                storyStackView.hidden = false
            }
        }
        
        if object.objectNumber == "" {
            objectNumberStackView.hidden = true
        } else {
            objectNumberStackView.hidden = false
        }
        
    }
    
    func heightForImage() -> CGFloat {
        let photo = object!.photo
        let width = self.photoImageView.frame.size.width
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRectWithAspectRatioInsideRect(photo!.size, boundingRect)
        let height = rect.size.height
        return height
    }
    
    func fixAllTexts(language: String) {
        titleFieldLabel.text = NSLocalizedString("title", comment:"")
        objectNumberFieldLabel.text = NSLocalizedString("objectnumber", comment:"")
        descriptionFieldLabel.text = NSLocalizedString("description", comment:"")
        locationFieldLabel.text = NSLocalizedString("location", comment:"")
        storyFieldLabel.text = NSLocalizedString("story", comment:"")
        
        //let backButton = UIBarButtonItem(title: NSLocalizedString("back", comment:""), style: UIBarButtonItemStyle.Plain, target: nil, action:nil)
        //objectCollectionViewController!.navigationItem.backBarButtonItem = backButton
        
        if language == "nl" {
            languageBtn.title = "English"
        } else {
            languageBtn.title = "Dutch"
        }
    }
    
    func fixScrollableView() {
        let heightFields = fieldsStackView.frame.size.height
        let heightImage = photoImageView.frame.size.height
        
        var height = heightFields
        if heightImage > heightFields {
            height = heightImage
        }
        
        var insets = scrollView.contentInset
        insets.top = 80.0
        scrollView.contentSize = CGSize(width: containerStackView.frame.width, height: height)
        scrollView.contentInset = insets
    }
    
    func createScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: .AlignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: .AlignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        scrollView.addSubview(containerStackView)
        scrollView.addSubview(outerView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerStackView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["containerStackView": containerStackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerStackView]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["containerStackView": containerStackView]))
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[outerView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["outerView": outerView]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[outerView]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["outerView": outerView]))
    }
    
    //
    //  Deprecated
    //  List deprecated methods
    //
}

