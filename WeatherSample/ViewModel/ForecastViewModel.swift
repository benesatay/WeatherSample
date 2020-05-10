//
//  ForecastViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 10.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class ForecastViewModel {
    var forecastData: ForecastWeatherModel?
    var selectedCityData = SelectedCityViewModel()

    var cityName: String = "İstanbul"
    
    //MARK: ForecastData
    func getForecastWeatherData(onSuccess: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        selectedCityData.getCityCoreData(compHandler: {
            if !self.selectedCityData.selectedCitiesArray.isEmpty {
                self.cityName = self.selectedCityData.selectedCitiesArray[0]
            }
            let getEndpoint = nextWeatherBaseURL
                .appending(self.cityName)
                .appending("\(apikey)")
                .appending("\(unit)")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: getEndpoint!) else { return}
            self.getData(from: url, completion: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let res = try JSONDecoder().decode(ForecastWeatherModel.self, from: data)
                    self.forecastData = res
                    onSuccess()
                } catch let error {
                    onError(error)
                }
            })
        })
    }
    
    func downloadForecastWeatherIcon(index: Int, completionHandler: @escaping (UIImage) -> Void) {
        getForecastWeatherData(onSuccess: {
            let iconName = self.forecastData?.list?[index].weather?[0].icon
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

extension ForecastViewModel {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
