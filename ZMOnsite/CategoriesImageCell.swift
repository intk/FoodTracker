//
//  CategoriesImageCell.swift
//  ZMOnsite
//
//  Created by Andre Goncalves on 16/02/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class CategoriesImageCell: UICollectionViewCell {
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Object? {
        didSet {
            if let photo = photo {
                imageView.image = photo.photo
            }
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageWidth.constant = attributes.photoWidth
            imageHeight.constant = attributes.photoHeight
        }
    }
}
