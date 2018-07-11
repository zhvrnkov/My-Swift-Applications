//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var tempUnit: UISwitch!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var unitF: UILabel!
    @IBOutlet weak var unitC: UILabel!
    
    @IBAction func switchTemp(_ sender: UISwitch) {
        temperatureLabel.text = "\(unitOfTemperature(sender.isOn))°"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //ассинхронный метод
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String: String]) {
        print(2)
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            responce in
            if responce.result.isSuccess {
                let weatherData: JSON = JSON(responce.result.value!)
                print(weatherData)
                self.updateWeatherData(json: weatherData)
                
            } else {
                print(responce.result.error!)
                self.cityLabel.text = "Connection Issues"
            }
        }
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        print(3)
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperatureC = Int(tempResult - 273.15)
            weatherDataModel.temperatureF = Int(1.8 * (tempResult - 273.15) + 32)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        print(4)
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(unitOfTemperature(tempUnit.isOn))°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    func unitOfTemperature(_ unit: Bool) -> Int {
        if unit == true {
            unitF.textColor = UIColor.green
            unitC.textColor = UIColor.white
            return weatherDataModel.temperatureF
        } else {
            unitF.textColor = UIColor.white
            unitC.textColor = UIColor.green
            return weatherDataModel.temperatureC
        }
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(1)
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            print("longitude = \(longitude), latitude = \(latitude)")
            
            let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
        
        
        
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        print(1)
        let params = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController // the type of segue.destination is going to be ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
}


