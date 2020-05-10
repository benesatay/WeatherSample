//
//  CityViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 10.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import Foundation

class TRCityViewModel {
    
    var cityData: TRCityModel?

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
