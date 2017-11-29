//
//  UIViewControllerExtension.swift
//  SampleApp
//
//  Created by Rodrigo Dumont on 10/08/17.
//  Copyright © 2017 RxDx. All rights reserved.
//

import UIKit

extension UIViewController {
    enum ErrorType {
        case warning
        case success
        case error
        case info
    }
    
    func showAlert(_ message: String, type: ErrorType = .warning, handler: ((UIAlertAction) -> Void)? = nil) {
        let controller = UIAlertController(title: AppName, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Entendi", style: .default, handler: handler))
        present(controller, animated: true, completion: nil)
    }
    
    func showLoading() {
        self.view.showLoading()
    }
    
    func hideLoading() {
        self.view.hideLoading()
    }
}
