//
//  TemperatureCollectionViewCell.swift
//  slate
//
//  Created by Alex Macmillan on 29/08/2015.
//  Copyright © 2015 x13N. All rights reserved.
//

import UIKit

class TemperatureCollectionViewCell: UICollectionViewCell {
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    @IBOutlet var highConstraint: NSLayoutConstraint!
    @IBOutlet var lowConstraint: NSLayoutConstraint!
    
    static let GUTTER_SIZE: CGFloat = 20.0
    
    func configure(weather: Weather, day: Day, height: CGFloat) {
        highLabel.text = String(day.max)
        lowLabel.text = String(day.min)
        
        let travel = height - TemperatureCollectionViewCell.GUTTER_SIZE * 2
        let pointsPerDegree = travel / CGFloat(weather.max - weather.min)
        let bottomDistance = TemperatureCollectionViewCell.GUTTER_SIZE + (pointsPerDegree * CGFloat(day.min - weather.min))
        let topDistance = TemperatureCollectionViewCell.GUTTER_SIZE + (pointsPerDegree * CGFloat(day.max - weather.min))
        
        highConstraint.constant = topDistance
        lowConstraint.constant = bottomDistance
    }
}
