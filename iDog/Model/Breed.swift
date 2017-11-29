//
//  Breed.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import SwiftyJSON

class Breed: Codable {

    var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}
