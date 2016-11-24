//
//  ExtractWeather.swift
//  WeatherApp
//
//  Created by Sona Jeswani on 11/22/16.
//  Copyright © 2016 Sona Jeswani. All rights reserved.
//

import Foundation


class ExtractWeather {
    
    
    static func retrieveDictionary(request: String) -> [String: String]{
    
        var weatherDict: [String: String] = [:]
    
        if let path = Bundle.main.path(forResource: request, ofType: "json")
        {
            
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    
                    let weatherData = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! [String:AnyObject]
                    
                } catch {
                    NSLog("Failed to make request for weather data from DarkSky API")
                }
                
            }
        }
    
    return weatherDict
}