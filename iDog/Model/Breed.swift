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
//    var isFavorite = false

    convenience init(name: String? = nil) {
        self.init()
        self.name = name
    }
    
    var isFavorite: Bool {
        guard let name = name, let favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] else {
            return false
        }
        return favorites.contains(name)
    }
    
    @discardableResult
    func addFavorite() -> Bool {
        guard let name = name else {
            return false
        }
        
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String]
        if favorites == nil {
            favorites = [String]()
        }
        
        if favorites?.contains(name) == true {
            favorites?.append(name)
        } else {
            favorites?.append(name)
        }
        
        UserDefaults.standard.set(favorites, forKey: "favorites")
        
        return true
    }
    
    @discardableResult
    func removeFavorite() -> Bool {
        guard let name = name, var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] else {
            return true
        }
        if let index = favorites.index(of: name) {
            favorites.remove(at: index)
            UserDefaults.standard.set(favorites, forKey: "favorites")
        }
        return true
    }
    
}
