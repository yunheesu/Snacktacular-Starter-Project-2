//
//  Double+roundTo.swift
//  Snacktacular
//
//  Created by Heesu Yun on 4/18/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation

//rounds any Double to "places" places, e.g. if value = 3.275, value.roundTo(places: 1) returns 3.3

extension Double {
    func roundTo(places: Int) -> Double {
        let tenToPower = pow(10.0, Double(  (places >= 0 ? places : 0 )  )) //places 가 0보다 크거나 같으면, use places, otherwise it's 0 
        let roundedValue = (self * tenToPower).rounded() / tenToPower // round to one decimal point
        return roundedValue
    }
}
