//
//  WeatherManager.swift
//  Clima
//
//  Created by Alex on 25.04.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weathermanager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f734de6bf203a56726a936c111c730be&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        print("Запрос с названием города\(urlString)")
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
     let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        print("Запрос с геопозицией\(urlString)")
    }
    
    func performRequest(with urlString: String) {
        //Create URL
        if let url = URL(string: urlString) {
            //Create URL Session
            let session = URLSession(configuration: .default)
            //Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("Поймали ошибку в WeatherManager func performRequest string 36, код ошибки \(error)")
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                                        
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp //температура
            let description =
                decodedData.weather[0].description
            let name = decodedData.name //Название города
            print("Введено название города \(name)")
            print("Температура \(temp)")
            print("Описание description \(description)")
            print("Описание main\(decodedData.weather[0].main)")
            print("Описание id\(decodedData.weather[0].id)")
            
            //getConditionName(weatherID: id)
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            print("Парсер описания id \( weather.conditionName)")
            print("Парсер название города \( weather.cityName)")
            print("Парсер температура в String \(weather.temperatureString)")
            print("Описание icon\(decodedData.weather[0].icon)")
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
                print("Поймали ошибку в WeatherManager string 81, код ошибки \(error)")
            return nil
        }
        
    }
    
    
}
