//
//  AnnotatedPhotoCell.swift
//  FoodTracker
//
//  Created by Andre Goncalves on 27/01/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var imageWidth: NSLayoutConstraint!
    @IBOutlet private weak var imageHeight: NSLayoutConstraint!
    
    var photo: Meal? {
        didSet {
            if let photo = photo {
                imageView.image = photo.photo
                //captionLabel.text = photo.caption
                //commentLabel.text = photo.comment
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
