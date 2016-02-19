//
//  PinterestLayout.swift
//  FoodTracker
//
//  Created by Andre Goncalves on 27/01/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
        withWidth:CGFloat) -> CGFloat
    // 2
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // 1
    var photoWidth: CGFloat = 0.0
    var photoHeight: CGFloat = 0.0
    
    // 2
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! PinterestLayoutAttributes
        copy.photoWidth = photoWidth
        copy.photoHeight = photoHeight
        return copy
    }
    
    // 3
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if( attributes.photoWidth == photoWidth  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class PinterestLayout: UICollectionViewLayout {
    // 1
    var delegate: PinterestLayoutDelegate!
    
    // 2
    var numberOfRows = 2
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    var currentOrientation: UIDeviceOrientation!
    
    // 3
    private var cache = [PinterestLayoutAttributes]()
    
    // 4
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat = 0.0
    
    var currentLayout: String = ""
    
    func preparePortraitLayout() {
        
        var insets = collectionView!.contentInset
        insets.top = 80.0
        insets.left = 8.0
        collectionView!.contentInset = insets
        contentHeight = CGFloat(0.0)
        contentWidth = CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        
        if let _ = self.delegate as? CategoriesCollectionViewController {
            numberOfRows = 1
            numberOfColumns = 3
            var insets = collectionView!.contentInset
            insets.top = 200.0
            insets.bottom = 5.0
            collectionView!.contentInset = insets
            contentHeight = CGFloat(0.0)
            contentWidth = CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        }
        
        self.collectionView!.alwaysBounceHorizontal = false
        self.collectionView!.alwaysBounceVertical = true
        
        
        cache = [PinterestLayoutAttributes]()
        
        // 1
        if cache.isEmpty {
            // 2
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            // 3
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                // 4
                let width = columnWidth - cellPadding * 2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath,
                    withWidth:width)
                
                let height = cellPadding + photoHeight //+ annotationHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                // 5
                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoHeight = photoHeight
                attributes.photoWidth = width
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : ++column
            }
        }
        
    }
    
    func prepareLandscapeLayout() {
        var insets = collectionView!.contentInset
        insets.top = 130.0
        insets.bottom = 130.0
        collectionView!.contentInset = insets
        
        contentHeight = CGRectGetHeight(collectionView!.bounds) - (insets.top + insets.bottom)
        contentWidth = CGFloat(0.0)
        
        self.collectionView!.alwaysBounceVertical = false
        
        if let _ = self.delegate as? CategoriesCollectionViewController {
            numberOfRows = 1
            numberOfColumns = 3
            
            var insets = collectionView!.contentInset
            insets.left = 200.0
            collectionView!.contentInset = insets
            
            contentHeight = CGRectGetHeight(collectionView!.bounds) - (insets.top + insets.bottom)
            contentWidth = CGFloat(0.0)
        }
        
        cache = [PinterestLayoutAttributes]()
        
        // 1
        if cache.isEmpty {
            // 2
            let columnHeight = contentHeight / CGFloat(numberOfRows)
            
            var yOffset = [CGFloat]()
            for row in 0 ..< numberOfRows {
                yOffset.append(CGFloat(row) * columnHeight)
            }
            
            var row = 0
            var xOffset = [CGFloat](count: numberOfRows, repeatedValue: 0)
            
            // 3
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                // 4
                let h = columnHeight - cellPadding * 2
                
                let photoWidth = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath,
                    withWidth:h)
                
                let w = 2 * cellPadding + photoWidth
                let frame = CGRect(x: xOffset[row], y: yOffset[row], width: w, height: columnHeight)
                
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                // 5
                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoWidth = photoWidth
                attributes.photoHeight = h
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6
                contentWidth = max(contentWidth, CGRectGetMaxX(frame))
                xOffset[row] = xOffset[row] + w
                
                row = row >= (numberOfRows - 1) ? 0 : ++row
            }
        }
    }
    
    override func prepareLayout() {
        if (UIDevice.currentDevice().orientation ==  .Portrait || UIDevice.currentDevice().orientation == .PortraitUpsideDown) {
            self.preparePortraitLayout()
        } else {
            self.prepareLandscapeLayout()
        }
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attribute = UICollectionViewLayoutAttributes()
        
        let layoutAttribute = cache[indexPath.row-1]
        attribute = layoutAttribute
        
        return attribute
    }
    
}
