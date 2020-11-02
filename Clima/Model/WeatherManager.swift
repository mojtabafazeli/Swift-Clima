//
//  WeatherManager.swift
//  Clima
//
//  Created by student on 2020-10-29.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    let weatherUrl =
    "https://api.openweathermap.org/data/2.5/weather?appid=afbb4f0507069e64801f01dee4882d1c&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJson(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
           
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        }
    
    
    
}
