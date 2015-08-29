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
        highConstraint.constant = TemperatureCollectionViewCell.calculateOffset(day.max, min: weather.min, max: weather.max, height: height)
        lowConstraint.constant = TemperatureCollectionViewCell.calculateOffset(day.min, min: weather.min, max: weather.max, height: height)
    }
    
    static func calculateOffset(temp: Int, min: Int, max: Int, height: CGFloat) -> CGFloat {
        let travel = height - TemperatureCollectionViewCell.GUTTER_SIZE*2
        let pointsPerDegree = travel / CGFloat(max - min)
        return TemperatureCollectionViewCell.GUTTER_SIZE + (pointsPerDegree * CGFloat(temp - min))
    }
}
