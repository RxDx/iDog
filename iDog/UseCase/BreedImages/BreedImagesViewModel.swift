//
//  BreedImagesViewModel.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import Foundation

protocol BreedImagesViewModelDelegate {
    func showLoading()
    func hideLoading()
    func updateUI()
}

class BreedImagesViewModel {

    var error: Error? = nil
    var delegate: BreedImagesViewModelDelegate?
    var breed: Breed?
    var breedImages: [String]?

    init(delegate: BreedImagesViewModelDelegate? = nil, breed: Breed?) {
        self.delegate = delegate
        self.breed = breed
    }
    
    func getBreedImages() {
        delegate?.showLoading()
        BreedsRepository().getImages(breed: breed) { (response) in
            self.delegate?.hideLoading()
            
            if let value = response.result.value {
                self.breedImages = try? JSONDecoder().decode([String].self, from: value)
            }
            
            self.delegate?.updateUI()
        }
    }
}
