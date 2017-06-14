//
//  HelperFunctions.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 13/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil) else { return nil }
        return html
    }
}



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

func convertToDouble(inputText: String) -> Double {
    let formatter = NumberFormatter()
    if let distance = (formatter.number(from: inputText)?.doubleValue) {
        return distance
    } else {
        return 0.0
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
        formatter.maximumFractionDigits = loopCount + 3
        formatter.minimumFractionDigits = loopCount + 3
        stringFromNumber = formatter.string(from: NSNumber(value: distance))!
        return stringFromNumber
    }
    return stringFromNumber
}


func showAlert(title: String, message: String) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)
        }
    }

extension Array {
    func rotate(directionAndDistance:Int) -> Array {
// rotates the contents of an array
// if directionAndDistance is a +ve integer array rotates up
// if directionAndDistance is a -ve integer array rotates down

        var array = Array()
        if (self.count > 0) {
            array = self
            if (directionAndDistance > 0) {
                for _ in 1...directionAndDistance {
                    array.append(array.remove(at: 0))
                }
            }
            else if (directionAndDistance < 0) {
                for _ in 1...abs(directionAndDistance) {
                    array.insert(array.remove(at: array.count-1),at:0)
                }
            }
        }
        return array
    }
}


func isInternetAvailable() -> Bool {

    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)

    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }

    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }

    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)

    return (isReachable && !needsConnection)
}






