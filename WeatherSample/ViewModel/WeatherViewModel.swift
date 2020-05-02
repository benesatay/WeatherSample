//
//  WeatherViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import CoreData

class WeatherViewModel {
    
    var cityData: TRCityModel?
    var currentWeatherData: CurrentWeatherModel?
    var forecastData: ForecastWeatherModel?
    var selectedCitiesArray = [String]()
    
    
    func getCityCoreData(compHandler: @escaping () -> Void)  {
        selectedCitiesArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                guard let name = result.value(forKey: "name") as? String else { return }
                self.selectedCitiesArray.insert(name, at: 0)
            }
        } catch {
            print("fetchrequest error")
        }
        compHandler()
    }
    
    func getCurrentWeatherData(onSuccess: @escaping () -> Void) {
        getCityCoreData(compHandler: {
            let cityName = self.selectedCitiesArray[0]
            let getEndpoint = currentWeatherBaseURL
                .appending(cityName)
                .appending("\(apikey)")
                .appending("\(unitAndLangAppendix)")
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
    
    func getForecastWeatherData(onSuccess: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        getCityCoreData(compHandler: {
            let cityName = self.selectedCitiesArray[0]
            let getEndpoint = nextWeatherBaseURL
                .appending(cityName)
                .appending("\(apikey)")
                .appending("\(unitAndLangAppendix)")
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
 
    func getTRcityList(onSuccess: @escaping () -> Void) {
        if let path = Bundle.main.path(forResource: "TRcityList", ofType:"json") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            guard data != nil else { return }
            let jsonObj = try? JSONDecoder().decode(TRCityModel.self, from:data!)
            self.cityData = jsonObj
            onSuccess()
        }
    }
}

extension WeatherViewModel {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

