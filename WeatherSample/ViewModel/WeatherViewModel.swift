//
//  WeatherViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class WeatherViewModel {
    
    var WeatherModel: Model?
    var icon: Weather?
    
    func getcurrentWeatherData(onSuccess: @escaping (Model?) -> Void, onError: @escaping (Error?) -> Void) {
        let getEndpoint = baseURL.appending("APPID=52fac2e571e411a42fedbe9676d8824c&units=metric&lang=tr").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: getEndpoint!) else { return}
        self.getData(from: url, completion: { (data, response, error) in
            guard let data = data else { return }
            let res = try? JSONDecoder().decode(Model.self, from: data)
            onSuccess(res)
        })
    }
    
    func downloadWeatherIcon(completionHandler: @escaping (UIImage) -> Void) {
        getcurrentWeatherData(onSuccess: { model in
            let iconName = model?.weather[0]?.icon
            let endpoint = iconName?.appending("@2x.png")
            let getEndpoint = iconBaseURL.appending("\(endpoint ?? "")").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print("Download Started")
            let url = URL(string: getEndpoint!)
            self.getData(from: url!) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                print(response?.suggestedFilename ?? url!.lastPathComponent)
                print("Download Finished")
                completionHandler(image)
            }
        }, onError: { error in
            print(error!)
        })
    }
}

extension WeatherViewModel {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
          URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
      }
}
