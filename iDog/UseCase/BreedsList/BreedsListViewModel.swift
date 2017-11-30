//
//  BreedsListViewModel.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import Foundation

protocol BreedListViewModelDelegate {
    func showLoading()
    func hideLoading()
    func updateUI()
}

class BreedsListViewModel {

    var breedsHash = [String: [Breed]]()
    var error: String? = nil
    var delegate: BreedListViewModelDelegate?
    var favoriteFilter = false
    
    init(delegate: BreedListViewModelDelegate? = nil, favoriteFilter: Bool = false) {
        self.delegate = delegate
        self.favoriteFilter = favoriteFilter
    }
    
    // MARK: - Repository
    func getBreeds() {
        self.breedsHash = [String: [Breed]]()
        delegate?.updateUI()

        if favoriteFilter {
            getFavoriteBreeds()
            return
        }
        
        delegate?.showLoading()
        BreedsRepository().all { (response) in
            self.delegate?.hideLoading()
            if response.result.isSuccess {
                let breeds = try? JSONDecoder().decode([String].self, from: response.result.value!)
                self.breedsHash = self.sortBreeds(breeds?.map({ (name) -> Breed in
                    Breed(name: name)
                }))
            } else {
                self.error = response.error?.localizedDescription ?? "Failed to get breed"
            }
            
            self.delegate?.updateUI()
        }
    }
    
    func getFavoriteBreeds() {
        let breeds = UserDefaults.standard.array(forKey: "favorites") as? [String]
        self.breedsHash = self.sortBreeds(breeds?.map({ (name) -> Breed in
            Breed(name: name)
        }))
        delegate?.updateUI()
    }
    
    // MARK: - Methods
    func sortBreeds(_ breeds: [Breed]?) -> [String: [Breed]] {
        guard let breeds = breeds else {
            return [String: [Breed]]()
        }
        
        breeds.forEach { (breed) in
            let breedName = breed.name?.first ?? "0"
            if breedsHash["\(breedName)"] == nil {
                breedsHash["\(breedName)"] = [Breed]()
            }
            
            breedsHash["\(breedName)"]?.append(breed)
        }
        
        return breedsHash
    }
    
    func numberOfSections() -> Int? {
        return breedsHash.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int? {
        let keys = Array(breedsHash.keys).sorted()
        let breedId = keys[section]
        return breedsHash[breedId]?.count
    }
    
    func breedFor(section: Int, row: Int) -> Breed? {
        let keys = Array(breedsHash.keys).sorted()
        if keys.isEmpty {
            return nil
        }
        return breedsHash[keys[section]]?[row]
    }
}
