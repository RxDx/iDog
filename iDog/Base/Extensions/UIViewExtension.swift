//
//  UIViewExtension.swift
//  SampleApp
//
//  Created by Rodrigo Dumont on 10/08/17.
//  Copyright © 2017 RxDx. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIView {
    
    func showLoading() {
        MBProgressHUD.showAdded(to: self, animated: true)
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: self, animated: true)
    }
}
