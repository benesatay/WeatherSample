//
//  WeatherViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class WeatherViewModel {
    
    var WeatherModel: WeatherModel?
    func getcurrentTempData(onSuccess: @escaping (NSDictionary, Error?) -> Void) {
        
        let getEndpoint = baseURL.appending("APPID=52fac2e571e411a42fedbe9676d8824c&units=metric").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: getEndpoint!) else { return}
        
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            guard data != nil else { return }
            do {
                var weatherJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                //print(weatherJson)
                onSuccess(weatherJson, nil)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
