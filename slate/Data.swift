//
//  Data.swift
//  slate
//
//  Created by Alex Macmillan on 29/08/2015.
//  Copyright © 2015 x13N. All rights reserved.
//

import UIKit
import Alamofire
import JSONJoy

class Data {
    static func weather(callback: (Weather) -> ()) {
        Alamofire.request(Alamofire.Method.GET, Constants.SERVER + "weather/")
            .response { request, response, data, error in
                if (error == nil) {
                    let weather_obj = Weather(JSONDecoder(data!))
                    callback(weather_obj)
                }
        }
    }
}
