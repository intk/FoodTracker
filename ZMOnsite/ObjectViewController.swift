//
//  ObjectViewController.swift
//  FoodTracker
//
//  Created by André Gonçalves on 19/01/15.
//  Copyright © 2016 INTK. All rights reserved.
//

import UIKit

class ObjectViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    //@IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var objectNumberTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var objectNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    /*
        This value is either passed by `ObjectTableViewController` in `prepareForSegue(_:sender:)`
        or constructed as part of adding a new Object.
    */
    var object: Object?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Object.
        if let object = object {
            navigationItem.title = object.name
            nameLabel.text   = object.name
            photoImageView.image = object.photo
            objectNumberLabel.text = object.objectNumber
            descriptionLabel.text = object.objectDescription
            storyTextView.text = object.story
            locationLabel.text = object.location
        }
        
        nameTextField.hidden = true
        objectNumberTextField.hidden = true
        descriptionTextField.hidden = true
        locationTextField.hidden = true
        
        
        // Enable the Save button only if the text field has a valid Object name.
        checkValidObjectName()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidObjectName()
        navigationItem.title = textField.text
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        //saveButton.enabled = false
    }
    
    func checkValidObjectName() {
        // Disable the Save button if the text field is empty.
        //let text = nameTextField.text ?? ""
        //saveButton.enabled = !text.isEmpty
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddObjectMode = presentingViewController is UINavigationController
        
        if isPresentingInAddObjectMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let objectNumber = objectNumberTextField.text ?? ""
            let objectDescription = descriptionTextField.text ?? ""
            let story = storyTextView.text ?? ""
            let location = locationTextField.text ?? ""
            
            // Set the Object to be passed to ObjectListTableViewController after the unwind segue.
            object = Object(name: name, photo: photo, objectNumber: objectNumber, description: objectDescription, story:story, location: location)
        }*/
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

}

