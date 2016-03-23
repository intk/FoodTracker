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
    var title_translation: String
    var photo: UIImage?
    var objectNumber: String
    var objectDescription: String
    var objectDescription_translation: String
    var story: String
    var story_translation: String
    var location: String
    var location_translation: String
    var imageURL: String
    var syncDate: String
    var link: String
    var imageChanged: Bool
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("objects")
    static let CategoriesArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("categories")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let titleTranslationKey = "title_translation"
        static let photoKey = "photo"
        static let objectNumberKey = "objectNumber"
        static let objectDescriptionKey = "objectDescription"
        static let objectDescriptionTranslationKey = "objectDescription_translation"
        static let storyKey = "story"
        static let storyTranslationKey = "story_translation"
        static let locationKey = "location"
        static let locationTranslation = "location_translation"
        static let imageURLKey = "imageURL"
        static let syncDate = "syncDate"
        static let linkKey = "link"
        static let imageChangedKey = "imageChanged"
    }

    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, objectNumber: String, description: String, story: String, location: String, syncDate: String, imageURL: String,
        title_translation: String, objectDescription_translation: String, location_translation: String, story_translation: String, link: String, imageChanged: Bool) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.objectNumber = objectNumber
        self.objectDescription = description
        self.story = story
        self.location = location
        self.imageURL = imageURL
        self.link = link
        self.syncDate = ""
        self.imageChanged = imageChanged
        
        self.title_translation = title_translation
        self.objectDescription_translation = objectDescription_translation
        self.location_translation = location_translation
        self.story_translation = story_translation
        
        super.init()
        
        // Initialization should fail if there is no name
        if name.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(title_translation, forKey: PropertyKey.titleTranslationKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(objectNumber, forKey: PropertyKey.objectNumberKey)
        aCoder.encodeObject(objectDescription, forKey: PropertyKey.objectDescriptionKey)
        aCoder.encodeObject(objectDescription_translation, forKey: PropertyKey.objectDescriptionTranslationKey)
        aCoder.encodeObject(story, forKey: PropertyKey.storyKey)
        aCoder.encodeObject(story_translation, forKey: PropertyKey.storyTranslationKey)
        aCoder.encodeObject(location, forKey: PropertyKey.locationKey)
        aCoder.encodeObject(location_translation, forKey: PropertyKey.locationTranslation)
        aCoder.encodeObject(imageURL, forKey: PropertyKey.imageURLKey)
        aCoder.encodeObject(syncDate, forKey: PropertyKey.syncDate)
        aCoder.encodeObject(link, forKey: PropertyKey.linkKey)
        aCoder.encodeObject(imageChanged, forKey: PropertyKey.imageChangedKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let title_translation = aDecoder.decodeObjectForKey(PropertyKey.titleTranslationKey) as! String
        
        // Because photo is an optional property of Object, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let objectNumber = aDecoder.decodeObjectForKey(PropertyKey.objectNumberKey) as! String
        let objectDescription = aDecoder.decodeObjectForKey(PropertyKey.objectDescriptionKey) as! String
        let objectDescription_translation = aDecoder.decodeObjectForKey(PropertyKey.objectDescriptionTranslationKey) as! String
        
        let story = aDecoder.decodeObjectForKey(PropertyKey.storyKey) as! String
        let story_translation = aDecoder.decodeObjectForKey(PropertyKey.storyTranslationKey) as! String
        
        let location = aDecoder.decodeObjectForKey(PropertyKey.locationKey) as! String
        let location_translation = aDecoder.decodeObjectForKey(PropertyKey.locationTranslation) as! String
        
        let imageURL = aDecoder.decodeObjectForKey(PropertyKey.imageURLKey) as! String
        let syncDate = aDecoder.decodeObjectForKey(PropertyKey.syncDate) as! String
        
        let link = aDecoder.decodeObjectForKey(PropertyKey.linkKey) as! String
        
        let imageChanged = aDecoder.decodeObjectForKey(PropertyKey.imageChangedKey) as? Bool ?? false

        
        // Must call designated initializer.
        self.init(name: name, photo: photo, objectNumber:objectNumber, description: objectDescription, story: story, location: location, syncDate: syncDate, imageURL: imageURL,
            title_translation: title_translation, objectDescription_translation: objectDescription_translation, location_translation: location_translation, story_translation: story_translation, link:link, imageChanged:imageChanged)
    }

}