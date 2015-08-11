//
//  ViewController.swift
//  Stormy
//
//  Created by Bob on 07/08/2015.
//  Copyright (c) 2015 Bob. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dailyWeather: DailyWeather? {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var summaryLabel: UILabel?
    @IBOutlet weak var sunriseTimeLabel: UILabel?
    @IBOutlet weak var sunsetTimeLabel: UILabel?
    @IBOutlet weak var lowTemperatureLabel: UILabel?
    @IBOutlet weak var highTemperatureLabel: UILabel?
    @IBOutlet weak var percipitationLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

    }
    
    func configureView() {
        if let weather = dailyWeather {
            self.title = weather.day
            // Update UI with information from the data model
            weatherIcon?.image = weather.largeIcon
            summaryLabel?.text = weather.summary
            sunriseTimeLabel?.text = weather.sunriseTime
            sunsetTimeLabel?.text = weather.sunsetTime
            
            if let lowTemp = weather.minTemperature,
                let highTemp = weather.maxTemperature,
                let rain = weather.percipChance,
                let humidity = weather.humidity {
                    lowTemperatureLabel?.text = "\(lowTemp)º"
                    highTemperatureLabel?.text = "\(highTemp)º"
                    percipitationLabel?.text = "\(rain)%"
                    humidityLabel?.text = "\(humidity)%"
            }
        }
        
        // set navbar font
        if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
            let barButtonAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: buttonFont
            ]
            
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, forState: .Normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

