//
//  ForecastService.swift
//  Stormy
//
//  Created by Bob on 07/08/2015.
//  Copyright (c) 2015 Bob. All rights reserved.
//

import Foundation
import UIKit


struct ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    init(APIKey: String) {
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "Https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    
    func getForecast(lat: Double, long: Double, completion: (Forecast? -> Void)) {
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: forecastBaseURL) {
            
            let networkOperation = NetworkOperation(url: forecastURL)
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                completion(forecast)
            }
            
        } else {
            println("Could not construct a valid url")
        }
    }
    
}