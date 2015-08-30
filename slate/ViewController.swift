
//
//  ViewController.swift
//  slate
//
//  Created by Alex Macmillan on 29/08/2015.
//  Copyright © 2015 x13N. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet var buttons: Array<UIButton>!
    @IBOutlet var weatherCollectionView: UICollectionView!
    @IBOutlet var currentTemperatureLineOffset: NSLayoutConstraint!
    @IBOutlet var currentTemperatureLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    let timeFormat = NSDateFormatter()
    
    var timeTimer: NSTimer?
    var weather: Weather = Weather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
            button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        }
        
        Data.weather(onWeather)
        
        timeFormat.setLocalizedDateFormatFromTemplate("HH:mm")
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        updateTime()
    }
    
    override func isBeingDismissed() -> Bool {
        timeTimer?.invalidate()
        return super.isBeingDismissed()
    }
    
    func buttonPressed(sender: UIView) {
        print("Button pressed")
        for button in buttons {
            button.selected = button == sender
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
    
    func onWeather(weather: Weather) {
        self.weather = weather
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.weatherCollectionView.reloadData()
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

}

