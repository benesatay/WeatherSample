//
//  SetupAlert.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 7.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class SetupAlert {
    func setupAlert(with vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
