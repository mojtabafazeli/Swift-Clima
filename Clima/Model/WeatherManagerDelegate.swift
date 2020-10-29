//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by student on 2020-10-29.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}
