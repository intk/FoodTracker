//
//  Object.swift
//  FoodTracker
//
//  Created by André Gonçalves on 19/01/15.
//  Copyright © 2016 INTK. All rights reserved.
//

import UIKit

class Object: NSObject, NSCoding {
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var objectNumber: String
    var objectDescription: String
    var story: String
    var location: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("objects")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let objectNumberKey = "objectNumber"
        static let objectDescriptionKey = "objectDescription"
        static let storyKey = "story"
        static let locationKey = "location"
    }

    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, objectNumber: String, description: String, story: String, location: String) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.objectNumber = objectNumber
        self.objectDescription = description
        self.story = story
        self.location = location
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(objectNumber, forKey: PropertyKey.objectNumberKey)
        aCoder.encodeObject(objectDescription, forKey: PropertyKey.objectDescriptionKey)
        aCoder.encodeObject(story, forKey: PropertyKey.storyKey)
        aCoder.encodeObject(location, forKey: PropertyKey.locationKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Object, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let objectNumber = aDecoder.decodeObjectForKey(PropertyKey.objectNumberKey) as! String
        let objectDescription = aDecoder.decodeObjectForKey(PropertyKey.objectDescriptionKey) as! String
        let story = aDecoder.decodeObjectForKey(PropertyKey.storyKey) as! String
        let location = aDecoder.decodeObjectForKey(PropertyKey.locationKey) as! String
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, objectNumber:objectNumber, description: objectDescription, story: story, location: location)
    }

}