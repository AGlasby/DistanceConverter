//
//  HelperFunctions.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 13/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import Foundation

func convertToScientific(distance: Double) -> String {
    let distanceNSNumber = NSNumber(value: Double(distance))
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.scientific
    formatter.positiveFormat = "0.####E+0"
    formatter.exponentSymbol = "e"
    if let stringFromNumber = formatter.string(from: distanceNSNumber) {
        return stringFromNumber
    } else {
        return "Error"
    }
}


func convertToDecimalString(distance: Double) -> String {
    var stringFromNumber:String = ""
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal

    if distance >= 100 {
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        stringFromNumber = formatter.string(from: NSNumber(value: distance))!
        return stringFromNumber
    }

    if distance >= 1 && distance < 100 {
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        stringFromNumber = formatter.string(from: NSNumber(value: distance))!
        return stringFromNumber
    }

    if distance == 0 {
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        stringFromNumber = formatter.string(from: NSNumber(value: distance))!
        return stringFromNumber
    }

    if distance < 1 {
        var check = distance
        var loopCount = 0
        while check < 1 {
            check = check * 10
            loopCount += 1
        }
        print(loopCount)
        formatter.maximumFractionDigits = loopCount + 3
        formatter.minimumFractionDigits = loopCount + 3
        stringFromNumber = formatter.string(from: NSNumber(value: distance))!
        return stringFromNumber
    }
    return stringFromNumber
}

