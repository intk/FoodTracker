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

class CategoriesCollectionViewController: UICollectionViewController, NSXMLParserDelegate {
    
    var categories = [Object]()
    var backButton: UIBarButtonItem!
    
    var objects = [Object]()
    
    var dateFormatter = NSDateFormatter()
    var xmlParser: NSXMLParser!
    var englishParse: Bool = false
    
    // RSS Feed
    var entryDictionary: [String:String]! = Dictionary()
    var entryTitle: String!
    var entryDescription: String!
    var entryObjectNumber: String!
    var entryStory: String!
    var entryCurrentLocation: String!
    var entryLink: String!
    
    var entrySyncDate: String!
    var entryImageURL: String!
    var entriesArray:[Dictionary<String, String>]! = Array()
    var currentParsedElement:String! = String()
    var urlRequest = NSMutableURLRequest()
    
    var isParsingCollection: Bool = false
    
    var collections: [String: [Object]]! = [String: [Object]]()
    
    // Pull to refresh
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var languageBtn: UIBarButtonItem!
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "languageDidChangeNotification:", name: "LANGUAGE_DID_CHANGE", object: nil)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // Data
        
        do {
            if let savedCategories = try loadCategories() {
                categories += savedCategories
            } else {
                // Load the sample data.
                loadRSSCategories()
            }
        
        } catch let error as NSError {
            print("Error while loading categories. Reconstructing database.")
            print(error.localizedDescription)
            loadRSSCategories()
        }
        //loadRSSCategories()
        
        do {
            collections = try self.loadCollections()
        } catch {
            //
        }

        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        // Collection view components
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        collectionView!.addSubview(refreshControl)
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        collectionView!.delaysContentTouches = false
        // Language
        checkLanguage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    
    // DATA PERSIST
    func loadCategories() throws -> [Object]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Object.CategoriesArchiveURL.path!) as? [Object]
    }
    
    func saveCategories() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(categories, toFile: Object.CategoriesArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save Categories...")
        }
    }
    
    func loadRSSCategories() {
        if Reachability.isConnectedToNetwork() == true {
            self.execRequest("zmcms", password:"zmcms", translation: self.englishParse)
        } else {
            refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("No_Internet_Connection", comment:""))
        }
    }
    
    func execRequest(username: String, password: String, translation: Bool) {
        
        print("Exec request.")
        /* Request with HTTP authentication */
        let username = "zmcms"
        let password = "zmcms"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        
        var zm_url = NSURL(string: "http://zm-cms.intk.com/nl/test-folder/app-sync/categories/RSS")
        if translation {
            zm_url = NSURL(string: "http://zm-cms.intk.com/nl/test-folder/app-sync/categories/RSS")
        }
        
        let urlRequest = NSMutableURLRequest(URL: zm_url!)
        urlRequest.HTTPMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) {
            (response, data, error) -> Void in
            self.xmlParser = NSXMLParser(data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
            self.loadImages()
        }
        
        
    }
    
    func loadImages() {
        for (index, object) in categories.enumerate() {
            if index == categories.count-1 {
                loadImage(object.imageURL, object: object, final: true)
            } else {
                loadImage(object.imageURL, object: object, final: false)
            }
        }
    }
    
    func loadCollections() throws -> [String: [Object]]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Object.ArchiveURL.path!) as? [String: [Object]]
    }
    
    
    //MARK: NSXMLParserDelegate
    func parser(parser: NSXMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName: String?,
        attributes attributeDict: [String : String]) {
            if elementName == "title" {
                entryTitle = String()
                currentParsedElement = "title"
            }
            
            if elementName == "description" {
                entryDescription = String()
                currentParsedElement = "description"
            }
            
            if elementName == "object_number" {
                entryObjectNumber = String()
                currentParsedElement = "object_number"
            }
            
            if elementName == "lead_media" {
                entryImageURL = String()
                currentParsedElement = "lead_media"
            }
            
            if elementName == "currentLocation" {
                entryCurrentLocation = String()
                currentParsedElement = "currentLocation"
            }
            
            if elementName == "link" {
                entryLink = String()
                currentParsedElement = "link"
            }
            
            if elementName == "content:encoded" {
                entryStory = String()
                currentParsedElement = "content:encoded"
            }
            
            if elementName == "dc:date" {
                entrySyncDate = String()
                currentParsedElement = "syncDate"
            }
    }
    
    func parser(parser: NSXMLParser,
        foundCharacters string: String){
            if currentParsedElement == "title" {
                entryTitle = entryTitle + string
            }
            
            if currentParsedElement == "description" {
                entryDescription = entryDescription + string
            }
            
            if currentParsedElement == "object_number" {
                entryObjectNumber = entryObjectNumber + string
            }
            
            if currentParsedElement == "lead_media" {
                entryImageURL = entryImageURL + string
            }
            
            if currentParsedElement == "currentLocation" {
                entryCurrentLocation = entryCurrentLocation + string
            }
            
            if currentParsedElement == "link" {
                entryLink = entryLink + string
            }

            
            if currentParsedElement == "content:encoded" {
                entryStory = entryStory + string
            }
            
            if currentParsedElement == "syncDate" {
                entrySyncDate = entrySyncDate + string
            }
    }
    
    func parser(parser: NSXMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?){
            if elementName == "title" {
                entryDictionary["title"] = entryTitle
            }
            
            if elementName == "description" {
                entryDictionary["description"] = entryDescription
            }
            
            if elementName == "object_number" {
                entryDictionary["object_number"] = entryObjectNumber
            }
            
            if elementName == "lead_media" {
                entryDictionary["lead_media"] = entryImageURL
            }
            
            if elementName == "currentLocation" {
                entryDictionary["currentLocation"] = entryCurrentLocation
            }
            
            if elementName == "link" {
                entryDictionary["link"] = entryLink
            }
            
            if elementName == "content:encoded" {
                let story = stripHTMLcontent(entryStory)
                entryDictionary["story"] = story
            }
            
            if elementName == "dc:date" {
                entryDictionary["syncDate"] = entrySyncDate
                entriesArray.append(entryDictionary)
                
                let photoName = "defaultPhoto"
                let defaultBlankPhoto = UIImage(named: photoName)!
                
                if entryDictionary["description"] == nil {
                    entryDictionary["description"] = ""
                }
                
                if entryDictionary["object_number"] == "None" {
                    entryDictionary["object_number"] = ""
                }
                
                // only add if object_number not in objects array
                // if object_number exists - update object instead
                
                let obj = findCategory(entryDictionary["link"]!)
                if obj != nil {
                    
                    if self.englishParse {
                        // Update english fields
                        obj?.title_translation = entryDictionary["title"]!
                        obj?.objectDescription_translation = entryDictionary["description"]!
                        obj?.story_translation = entryDictionary["story"]!
                        obj?.location_translation = entryDictionary["currentLocation"]!
                    } else {
                        // Regular fields
                        obj?.name = entryDictionary["title"]!
                        obj?.objectNumber = entryDictionary["object_number"]!
                        obj?.objectDescription = entryDictionary["description"]!
                        
                        // Extra fields that need to be synced
                        obj?.story = entryDictionary["story"]!
                        obj?.location = entryDictionary["currentLocation"]!
                        
                        if obj?.imageURL != entryDictionary["lead_media"]! {
                            // Update new lead media - image is different
                            print("different url")
                            obj?.imageURL = entryDictionary["lead_media"]!
                            
                        } else {
                            // do not update - image is the same
                        }
                    }
                    
                    obj?.syncDate = entryDictionary["syncDate"]!
                } else {
                    if !self.englishParse {
                        if entryDictionary["lead_media"]! != "" {
                            let createdObject = Object(name: entryDictionary["title"]!, photo: defaultBlankPhoto, objectNumber:entryDictionary["object_number"]!, description:entryDictionary["description"]!, story:entryDictionary["story"]!, location:entryDictionary["currentLocation"]!, syncDate:entryDictionary["syncDate"]!, imageURL: entryDictionary["lead_media"]!, title_translation: "", objectDescription_translation:"", location_translation:"", story_translation:"", link: entryDictionary["link"]!)!
                            
                            
                            categories.append(createdObject)
                        } else {
                            // do not create if there's no image
                        }
                    } else {
                        // do not create if english
                    }
                }
            }
    }
    
    func stripHTMLcontent(string: String) -> String {
        let str = string.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        let strippedHTML = str.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        return strippedHTML
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        saveCategories()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.collectionView?.reloadData()
        })
    }
    
    func findCategory(link: String) -> Object? {
        for object in categories {
            let trimmedObjectLink = object.link.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            
            if trimmedObjectLink == link {
                return object
            }
        }
        return nil
    }
    
    func loadImage(urlString:String, object:Object, final: Bool) {
        let username = "zmcms"
        let password = "zmcms"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        let imgURL: NSURL = NSURL(string: urlString+"/@@images/image/large")!
        
        let request = NSMutableURLRequest(URL: imgURL)
        request.HTTPMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let object = object
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil) {
                func display_image() {
                    let new_image = UIImage(data: data!)
                    object.photo = new_image
                    
                    if final {
                        self.saveCategories()
                    }
                    self.collectionView?.reloadData()
                }
                dispatch_sync(dispatch_get_main_queue(), display_image)
            } else {
                // Do something with the error.
            }
        }
        task.resume()
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
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        print("Refresh control")
        
        if Reachability.isConnectedToNetwork() == true {
            
            //objects = [Object]()
            self.englishParse = false
            self.execRequest("zmcms", password: "zmcms", translation: self.englishParse)
            let now = NSDate()
            let updateString = NSLocalizedString("Last_Updated_at", comment:"") + " " + self.getFormattedStringFromDate(now)
            refreshControl.attributedTitle = NSAttributedString(string: updateString)
            
        } else {
            refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("No_Internet_Connection", comment:""))
        }
        
        refreshControl.endRefreshing()
    }
    
    func getFormattedStringFromDate(aDate: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        return self.dateFormatter.stringFromDate(aDate)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        /*let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoriesImageCell
        let imageView = cell.imageView
        imageView.alpha = 0.8*/
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        /*let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoriesImageCell
        let imageView = cell.imageView
        imageView.alpha = 1*/
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("showObjects segue")

        // Get the cell that generated this segue.
        if segue.identifier == "showObjects" {
            let ObjectViewController = segue.destinationViewController as! ObjectCollectionViewController
            if let selectedObjectCell = sender as? CategoriesImageCell {
                let indexPath = collectionView!.indexPathForCell(selectedObjectCell)!
                let selectedCategory = categories[indexPath.row]
                let selectedLink = selectedCategory.link
                ObjectViewController.currentCollection = selectedLink
                
                ObjectViewController.test_dict = self.collections
                /*let collectionExists = self.collections[selectedLink] != nil
                if collectionExists {
                    ObjectViewController.objects = self.collections[selectedLink]!
                }*/
            }
        }
        else {
            // do nothing
        }
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

