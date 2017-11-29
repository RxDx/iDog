//
//  BreedsRepository.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

class BreedsRepository: BaseRepository {
    
    init() {
        super.init(url: "")
    }
    
    override func all(_ then: @escaping BaseRepository.ThenBlock) {
        super.customGet("breeds", then: then)
    }
    
    func getImages(breed: Breed?, then: @escaping ThenBlock) {
        super.customGet("\(breed!.name!)/images", then: then)
    }
    
}
