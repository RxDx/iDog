//
//  iDogTabBarController.swift
//  iDog
//
//  Created by Rodrigo Dumont on 29/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import UIKit

class iDogTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let controller = BreedsListController.storyboardInstance(favoriteFilter: false) {
            controller.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 419)
            controller.tabBarItem.title = "ALL"
            addChildViewController(controller)
        }
        if let controller = BreedsListController.storyboardInstance(favoriteFilter: true) {
            controller.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 420)
            controller.tabBarItem.title = "FAVORITES"
            addChildViewController(controller)
        }
    }
}
