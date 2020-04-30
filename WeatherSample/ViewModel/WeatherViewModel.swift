//
//  WeatherViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class WeatherViewModel {
    
    var currentWeatherModel: CurrentWeatherModel?
    var forecastWeatherModel: ForecastWeatherModel?
    
    func getCurrentWeatherData(onSuccess: @escaping (CurrentWeatherModel?) -> Void, onError: @escaping (Error?) -> Void) {
        let getEndpoint = currentWeatherBaseURL.appending("\(apikey)").appending("\(unitAndLangAppendix)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: getEndpoint!) else { return}
        self.getData(from: url, completion: { (data, response, error) in
            guard let data = data else { return }
            let res = try? JSONDecoder().decode(CurrentWeatherModel.self, from: data)
            self.currentWeatherModel = res
            onSuccess(res)
        })
    }
    
    func downloadCurrentWeatherIcon(completionHandler: @escaping (UIImage) -> Void) {
        getCurrentWeatherData(onSuccess: { model in
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
    
    func getForecastWeatherData(onSuccess: @escaping (ForecastWeatherModel) -> Void, onError: @escaping (Error?) -> Void) {
        let getEndpoint = nextWeatherBaseURL.appending("\(apikey)").appending("\(unitAndLangAppendix)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: getEndpoint!) else { return}
        self.getData(from: url, completion: { (data, response, error) in
            guard let data = data else { return }
            do {
                let res = try JSONDecoder().decode(ForecastWeatherModel.self, from: data)
                self.forecastWeatherModel = res
                onSuccess(res)
            } catch let error {
                onError(error)
            }
        })
    }
    
    func downloadForecastWeatherIcon(index: Int, completionHandler: @escaping (UIImage) -> Void) {
        getForecastWeatherData(onSuccess: { model in
            let iconName = model.list?[index].weather?[0].icon
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
