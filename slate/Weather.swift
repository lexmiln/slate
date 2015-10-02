//
//  Weather.swift
//  slate
//
//  Created by Alex Macmillan on 29/08/2015.
//  Copyright © 2015 x13N. All rights reserved.
//

import UIKit
import JSONJoy

struct Weather: JSONJoy {
    var current: Int = 0
    var max: Int = 0
    var min: Int = 0
    var daily: Array<Day> = []
    init(){}
    init(_ decoder: JSONDecoder) {
        current = decoder["current"].integer!
        max = decoder["max"].integer!
        min = decoder["min"].integer!
        
        if let days = decoder["daily"].array {
            for dayDecoder in days[0..<5] {
                daily.append(Day(dayDecoder))
            }
        }
    }
}

struct Day: JSONJoy {
    var colorString: String = "#000000"
    var max: Int = 0
    var min: Int = 0
    var weatherString: String = "unknown"
    init(){}
    init(_ decoder: JSONDecoder) {
        colorString = decoder["color"].string!
        max = decoder["max"].integer!
        min = decoder["min"].integer!
        weatherString = decoder["weather"].string!
    }
}
