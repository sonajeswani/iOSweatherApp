//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sona Jeswani on 11/16/16.
//  Copyright © 2016 Sona Jeswani. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import Alamofire
import AddressBookUI

class ViewController: UIViewController {
    
    let APIkey = "295a15b47e1a3e4649c5f43bfa41a17e"
    var locationManager: CLLocationManager = CLLocationManager()
    
    var temperature: Double?
    var latitude: Double?
    var longitude: Double?
    var rainPossibility: Bool?
    var hourWillRain: Int?
    var minWillRain: Int?
    
    var weatherSummary: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let lastlocation = locationArray.lastObject as! CLLocation
        self.newLocation = lastlocation
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    
    func setUpLabels() {
        
        let summaryLabel = UILabel(frame: CGRect(x: view.frame.width / 10, y: view.frame.height / 6 + view.frame.width / 2, width: view.frame.width * 0.7, height: 60))
        summaryLabel.text = weatherSummary
        summaryLabel.textAlignment = .center
        view.addSubview(summaryLabel)
        
        
        let temperatureLabel = UILabel(frame: CGRect(x: view.frame.width / 10, y: 40, width: view.frame.width * 0.7, height: 40))
        temperatureLabel.text = String(temperature)
        temperatureLabel.textAlignment = .center
        view.addSubview(temperatureLabel)
        
        let cityLabel = UILabel(frame: CGRect(x: view.frame.width / 10, y: 70, width: view.frame.width * 0.8, height: 20))
        view.addSubview(cityLabel)
        
        let rainPossibilityLabel = UILabel(frame: CGRect(x: view.frame.width / 10, y: 40, width: view.frame.width * 0.8, height: 30))
        
        if (rainPossibility == true) {
            
            rainPossibilityLabel.text = "It will rain at " + String(hourWillRain) + ":" + String(minWillRain)
            rainPossibilityLabel.textAlignment = .center
            view.addSubview(rainPossibilityLabel)
            
        } else {
            rainPossibilityLabel.text = "It will not rain today."
            
        }
        
    }
    
    func retreiveWeatherDetails() {
        
        Alamofire.request("https://api.darksky.net/forecast/\(APIkey)/\(latitude!),\(longitude!)").responseJSON { response in
            if let JSON = response.result.value {
                
                //extracts current info directly from JSON file
                let tempMin = JSON["minutely"] as? [String: AnyObject]
                let tempHour = JSON["hourly"] as? [String: AnyObject]
                let tempCurr = JSON["currently"] as? [String: AnyObject]
                let incomingDataByMin = tempMin?["data"] as? [[String: AnyObject]]
                
                //sets the class variables using the temporary data extracted above
                self.temperature = tempCurr?["temperature"] as? Double
                self.rainPossibility = (tempMin?["icon"] as! String == "rain")
                self.weatherSummary = tempHour?["summary"] as! String!
                
                //if it will rain, must iterate through the data in list 
                if(self.rainPossibility == true) {
                    for eachDict in incomingDataByMin!{
                        if(eachDict["precipProbability"] as! Double == 1.0){
                            //we must set the rain instance variables
                            let hexTime: AnyObject = d["time"] as AnyObject
                            let date = NSDate(timeIntervalSince1970: hexTime as! TimeInterval)
                            print(date)
                            let calendar = NSCalendar.current
                            self.minWillRain = calendar.component(.minute, from: date as Date)
                            self.hourWillRain = calendar.component(.hour, from: date as Date)
                            break
                            
                        }
                
                
            }
            
        }
    }


}

