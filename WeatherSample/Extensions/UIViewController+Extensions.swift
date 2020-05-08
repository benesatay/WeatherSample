//
//  UIViewController+Extensions.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 8.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension UIViewController {
    var topBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return (UIApplication.shared.statusBarFrame.size.height) + (self.navigationController?.navigationBar.frame.size.height ?? 0.0)
        }
    }
}

