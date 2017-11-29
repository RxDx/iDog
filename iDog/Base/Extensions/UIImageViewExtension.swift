//
//  UIImageViewExtension.swift
//  SampleApp
//
//  Created by Rodrigo Dumont on 10/08/17.
//  Copyright © 2017 RxDx. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadFrom(url: String?) {
        let url = URL(string: url ?? "")
        kf.setImage(with: url)
    }
}
