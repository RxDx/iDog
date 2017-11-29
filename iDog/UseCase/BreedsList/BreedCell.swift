//
//  BreedCell.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import UIKit

class BreedCell: UITableViewCell {

    @IBOutlet weak var breedImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    
    var breed: Breed? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI() {
        breedImageView.image = UIImage(named: "dog")
        breedLabel.text = breed?.name
        
        heartImageView.tintColor = .red
        heartImageView.isHidden = breed?.isFavorite != true
    }
}
