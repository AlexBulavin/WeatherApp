//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self //Последовательность вызовов должна быть такой, чтобы locationManager.delegate = self был раньше авторизации и запроса локации
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        //        print(searchTextField.text!)
    }
    @IBAction func getLocation(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.locationManager.requestLocation()
            print("Кнопка getLocation нажата")
        }
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPresserd(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
        //print(searchTextField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        //        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {//print(searchTextField.text!)
            return true
        }
        else {
            textField.placeholder = "Поиск"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // api.openweathermap.org/data/2.5/weather?q={city name}&appid={your api key}
        
        // api.openweathermap.org/data/2.5/weather?q={city name},{state}&appid={your api key}
        
        // api.openweathermap.org/data/2.5/weather?q={city name},{state},{country code}&appid={your api key}
        
        
        // API key f734de6bf203a56726a936c111c730be
        //        print(searchTextField.text!)
        //Use searchTextField.text to get the weather for that city
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weathermanager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            
        }
        
        //print(weather.temperature)
    }
    func didFailWithError(error: Error) {
        print("Поймали ошибку в WeatherViewController string 76, код ошибки \(error)")
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            if let location = locations.last {
                self.locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                print("Got location data \(lat); \(lon)")
                self.weatherManager.fetchWeather(latitude: lat, longitude: lon)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка при получении геолокации \(error)")
    }
    //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={your api key}
    
}
