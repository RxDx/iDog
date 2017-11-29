//
//  BreedImageCell.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import UIKit

class BreedImageCell: UICollectionViewCell {
    
    @IBOutlet weak var breedImageView: UIImageView!
    
    var breedImage: String? {
        didSet {
            breedImageView.loadFrom(url: breedImage)
        }
    }

}
