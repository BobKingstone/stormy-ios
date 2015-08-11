//
//  WeeklyTableTableViewController.swift
//  Stormy
//
//  Created by Bob on 08/08/2015.
//  Copyright (c) 2015 Bob. All rights reserved.
//

import UIKit

class WeeklyTableTableViewController: UITableViewController {

    
    private let forecastAPIKey = "253ff1044fcd6d25826081aeccad018d"
    let coordinat: (lat: Double, long: Double) = (37.8267, -122.423)
    
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPercipitationLabel: UILabel?
    @IBOutlet weak var currentRangeLabel: UILabel?
    
    var weeklyWeather: [DailyWeather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getForecastData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func refreshWeather() {
        getForecastData()
        refreshControl?.endRefreshing()
    }
    
    func configureView() {
        // set table views background property
        tableView.backgroundView = BackgroundView()
        
        tableView.rowHeight = 64
        
        // set navbar font
        if let navbarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
            let navbarAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: navbarFont
            ]
        
            navigationController?.navigationBar.titleTextAttributes = navbarAttributesDictionary
        }
        
        // position refresh control above background view
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.whiteColor()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDaily" {
            if let indexPath = tableView.indexPathForSelectedRow() {
                let dailyWeather = weeklyWeather[indexPath.row]
                
                (segue.destinationViewController as! ViewController).dailyWeather = dailyWeather
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return weeklyWeather.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! DailyWeatherTableViewCell

        let dailyWeather = weeklyWeather[indexPath.row]
        if let maxTemp = dailyWeather.maxTemperature {
            cell.temperatureLabel.text = "\(maxTemp)º"
        }
        
        cell.weatherIcon.image = dailyWeather.icon
        cell.dayLabel.text = dailyWeather.day
        
        return cell
    }
    
    
    
    // MARK: = Delegate Methods
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 170/255.0, green: 131/255.0, blue: 224/255.0, alpha: 1.0)
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel.font = UIFont(name: "HeleveticaNeue-Thin", size: 14.0)
            header.textLabel.textColor = UIColor.whiteColor()
        }
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        cell?.selectedBackgroundView = highlightView
    }
    
    
    // MARK: - Weather Data fetching
    
    func getForecastData() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinat.lat, long: coordinat.long) {
            (let forecast ) in
            if let weatherForecast = forecast {
                if let currentWeather = weatherForecast.currentWeather {
                    dispatch_async(dispatch_get_main_queue()) {
                        if let temperature = currentWeather.temperature {
                            self.currentTemperatureLabel?.text = "\(temperature)º"
                        }
                    
                        if let percip = currentWeather.precipProbability {
                            self.currentPercipitationLabel?.text = "Rain: \(percip)º"
                        }
                    
                        if let icon = currentWeather.icon {
                            self.currentWeatherIcon?.image = icon
                        }
                        
                        self.weeklyWeather = weatherForecast.weekly
                        
                        if let highTemp = self.weeklyWeather.first?.maxTemperature,
                            let lowTemp = self.weeklyWeather.first?.minTemperature {
                                self.currentRangeLabel?.text = "↑\(highTemp)º↓\(lowTemp)º"
                        }
                        
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
    }


}
