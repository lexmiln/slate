
//
//  ViewController.swift
//  slate
//
//  Created by Alex Macmillan on 29/08/2015.
//  Copyright © 2015 x13N. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet var buttons: Array<UIButton>!
    @IBOutlet var weatherCollectionView: UICollectionView!
    @IBOutlet var currentTemperatureLineOffset: NSLayoutConstraint!
    @IBOutlet var currentTemperatureLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    let timeFormat = NSDateFormatter()
    var weather: Weather = Weather()
    
    var timeTimer: NSTimer?
    var weatherTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
            button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        }
        
        timeFormat.setLocalizedDateFormatFromTemplate("HH:mm")
        updateTime()
        updateWeather()

        timeTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        weatherTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "updateWeather", userInfo: nil, repeats: true)
    }
    
    deinit {
        timeTimer?.invalidate()
        weatherTimer?.invalidate()
    }
    
    func buttonPressed(sender: UIView) {
        print("Button pressed")
        for button in buttons {
            button.selected = button == sender
        }
        
        if let command = sender.valueForKey("command") as! String? {
            Alamofire.request(Alamofire.Method.GET, Constants.SERVER + "do/" + command).response(completionHandler: { (_, _, _, _) -> Void in
                print("Command sent")
            })
        }
    
    }

    func listenForCommand() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let request = app.apiAI.requestWithType(.Voice)
        request.setCompletionBlockSuccess({ (request, response) -> Void in
            print("Success", response)
            }) { (request, error) -> Void in
                print("Error", error)
        }
        app.apiAI.enqueue(request)
    }
    
    func updateTime() {
        timeLabel.text = timeFormat.stringFromDate(NSDate())
    }
    
    func updateWeather() {
        Data.weather(onWeather)
    }
    
    func onWeather(weather: Weather) {
        let canUpdateCells = weather.daily.count == weatherCollectionView.numberOfItemsInSection(0)
        self.weather = weather
        
        if !canUpdateCells {
            self.weatherCollectionView.reloadData()
        }
        
        UIView.animateWithDuration(0.5) { () -> Void in
            if canUpdateCells {
                for i in 0..<self.weather.daily.count {
                    let cell = self.weatherCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! TemperatureCollectionViewCell
                    cell.configure(self.weather,
                        day: self.weather.daily[i],
                        height: self.weatherCollectionView.frame.height)
                }
            }
            
            self.currentTemperatureLabel.text = String(format:"%i°", weather.current)
            self.currentTemperatureLineOffset.constant = TemperatureCollectionViewCell.calculateOffset(weather.current,
                min: weather.min,
                max: weather.max,
                height: self.weatherCollectionView.frame.height)
            self.view.layoutIfNeeded()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weather.daily.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("temperature", forIndexPath: indexPath) as! TemperatureCollectionViewCell
        cell.configure(weather, day: weather.daily[indexPath.row], height: weatherCollectionView.frame.height)
        return cell
    }
    
    override func shouldAutorotate() -> Bool {
        return true;
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }

}

