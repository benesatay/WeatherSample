//
//  WeatherViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class WeatherViewModel {
    
    var currentWeatherData: CurrentWeatherModel?
    var selectedCityData = SelectedCityViewModel()
    
    var cityName: String = "İstanbul"
    
    //MARK: Current Data
    func getCurrentWeatherData(onSuccess: @escaping () -> Void) {
        selectedCityData.getCityCoreData(compHandler: {
            if !self.selectedCityData.selectedCitiesArray.isEmpty {
                self.cityName = self.selectedCityData.selectedCitiesArray[0]
            }
            
            let getEndpoint = currentWeatherBaseURL
                .appending(self.cityName)
                .appending("\(apikey)")
                .appending("\(unit)")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let url = URL(string: getEndpoint!) else { return}
            self.getData(from: url, completion: { (data, response, error) in
                guard let data = data else { return }
                let res = try? JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                self.currentWeatherData = res
                onSuccess()
            })
        })
    }
    
    func downloadCurrentWeatherIcon(completionHandler: @escaping (UIImage) -> Void) {
        getCurrentWeatherData(onSuccess: {
            let iconName = self.currentWeatherData?.weather[0]?.icon
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
        })
    }
    
}

extension WeatherViewModel {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

