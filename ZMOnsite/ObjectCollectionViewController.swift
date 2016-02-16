//
//  ObjectCollectionViewController.swift
//  FoodTracker
//
//  Created by Andre Goncalves on 27/01/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ObjectCollectionViewController: UICollectionViewController, NSXMLParserDelegate {
    
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
    
    var entrySyncDate: String!
    var entryImageURL: String!
    var entriesArray:[Dictionary<String, String>]! = Array()
    var currentParsedElement:String! = String()
    var urlRequest = NSMutableURLRequest()

    var backButton: UIBarButtonItem!
    
    // Pull to refresh
    var refreshControl: UIRefreshControl!
    
    // Language button
    @IBOutlet weak var languageBtn: UIBarButtonItem!
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "languageDidChangeNotification:", name: "LANGUAGE_DID_CHANGE", object: nil)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle

        // Do any additional setup after loading the view.
        // Load any saved Objects, otherwise load sample data.
        
        if let savedObjects = loadObjects() {
            objects += savedObjects
        } else {
            // Load the sample data.
            loadRSSObjects()
        }
        //loadRSSObjects()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        collectionView!.addSubview(refreshControl)
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        checkLanguage()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.collectionView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
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
                ObjectDetailViewController.objectCollectionViewController = self
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new Object.")
        }
    }
    
    // Actions
    @IBAction func unwindToObjectCollectionList(sender: UIStoryboardSegue) {
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
        print("[Collection] Language did change")
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
        print("[Collection] check language")
        
        let preferredLanguage = NSUserDefaults.standardUserDefaults().valueForKey("selectedLanguage") as? String
        print(preferredLanguage)
        
        if preferredLanguage == "nl" {
            languageBtn.title = NSLocalizedString("English", comment:"")
        } else {
            languageBtn.title = NSLocalizedString("Dutch", comment:"")
        }
    }
    
    
    // Data persist func
    func saveObjects() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(objects, toFile: Object.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save Objects...")
        }
    }
    
    func loadObjects() -> [Object]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Object.ArchiveURL.path!) as? [Object]
    }
    
    func loadRSSObjects() {
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
        
        var zm_url = NSURL(string: "http://zm-cms.intk.com/nl/test-folder/app-sync/aggregator/RSS")
        if translation {
            zm_url = NSURL(string: "http://zm-cms.intk.com/en/test-folder/app-sync/aggregator/RSS")
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
        }
    }
    
    func getEnglishContent() {
        self.englishParse = true
        print("Finished parsing. Get translation content.")
        self.handleRefresh(self.refreshControl)
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
            
            if elementName == "content:encoded" {
                entryStory = String()
                currentParsedElement = "story"
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
            
            if elementName == "content:encoded" {
                if !self.englishParse {
                    entryDictionary["story"] = "Zwartvoet Indianen zijn van oorsprong jagers. Voor hun kleding en gebruiksvoorwerpen maken ze gebruik van materialen die voorhanden zijn. Deze jurk is gemaakt van leer. Het is een kledingstuk voor dagelijks gebruik. De jurk is versierd met kralen, franjes en belletjes. Oorspronkelijk is de jurk waarschijnlijk ook met hermelijnbont gedecoreerd geweest, maar hiervan zijn geen resten meer over. Met de komst van Europese kolonisten komt vanaf de 19e eeuw ook westerse kleding beschikbaar voor de Zwartvoet. De traditionele leren kleding wordt sindsdien vooral nog op bijzondere gelegenheden gedragen."
                } else {
                    entryDictionary["story"] = "Zwartvoet Indianen originating hunters. This dress is made of leather. It is a garment for everyday use. The dress is decorated with beads, tassels and bells. Originally, the dress probably been decorated with ermine fur, but these are no residues left. With the arrival of European settlers coming from the 19th century, western clothing available for the Blackfeet. The traditional leather clothing since then is mostly still worn on special occasions."
                }
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
                
                let obj = findObject(entryDictionary["object_number"]!)
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
                            obj?.imageURL = entryDictionary["lead_media"]!
                            loadImage(entryDictionary["lead_media"]!, object: obj!)
                        } else {
                            // do not update - image is the same
                        }
                    }

                    obj?.syncDate = entryDictionary["syncDate"]!
                } else {
                    if !self.englishParse {
                        if entryDictionary["lead_media"]! != "" {
                            let createdObject = Object(name: entryDictionary["title"]!, photo: defaultBlankPhoto, objectNumber:entryDictionary["object_number"]!, description:entryDictionary["description"]!, story:entryDictionary["story"]!, location:entryDictionary["currentLocation"]!, syncDate:entryDictionary["syncDate"]!, imageURL: entryDictionary["lead_media"]!, title_translation: "", objectDescription_translation:"", location_translation:"", story_translation:"")!
                        
                            loadImage(entryDictionary["lead_media"]!, object:createdObject)
                        
                            objects.append(createdObject)
                        } else {
                            // do not create if there's no image
                        }
                    } else {
                        // do not create if english
                    }
                }
            }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if !self.englishParse {
            self.getEnglishContent()
        } else {
            saveObjects()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView?.reloadData()
            })
        }
    }
    
    func findObject(object_number: String) -> Object? {
        for object in objects {
            let trimmedObjectNumber = object.objectNumber.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            
            if trimmedObjectNumber == object_number {
                return object
            }
        }
        return nil
    }
    
    func loadImage(urlString:String, object:Object) {
        let username = "zmcms"
        let password = "zmcms"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        let imgURL: NSURL = NSURL(string: urlString)!
        
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
                    
                    //TODO: Performance bottleneck for first load
                    self.saveObjects()
                    self.collectionView?.reloadData() //TODO: there must be a more efficient way of doing this.
                }
                dispatch_sync(dispatch_get_main_queue(), display_image)
            } else {
                // Do something with the error.
            }
        }
        task.resume()
    }
    //  Pull to refresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        print("Refresh control")
        
        if Reachability.isConnectedToNetwork() == true {
            entriesArray = Array()
            
            //objects = [Object]()
            
            self.execRequest("zmcms", password:"zmcms", translation: self.englishParse)
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

