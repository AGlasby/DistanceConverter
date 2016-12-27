//
//  AstroDistance.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 13/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import Foundation

struct AstroDistance {
    var fromParsecs = 1.0
    var parsecsToKilometres = 3.08567758149137e13 //per parsec
    var parsecsToAstronomicalUnits = 2.0626481e5 //per parsec
    var parsecsToLightYears = 3.2615638 //per parsec

    var kilometresToParsecs:Double!
    var kilometresToAstronomicalUnits:Double!
    var kilometresToLightYears:Double!

    var astronomicalUnitsToParsecs:Double!
    var astronomicalUnitsToKilometres:Double!
    var astronomicalUnitsToLightYears:Double!

    var lightYearsToParsecs:Double!
    var lightYearsToKilometres:Double!
    var LightYearsToAstronomicalUnits:Double!


    init() {
        //  From kilometres
        kilometresToParsecs = 1 / parsecsToKilometres
        kilometresToAstronomicalUnits = kilometresToParsecs * parsecsToAstronomicalUnits
        kilometresToLightYears = kilometresToParsecs * parsecsToLightYears

        // From astronomical units
        astronomicalUnitsToParsecs = 1 / parsecsToAstronomicalUnits
        astronomicalUnitsToKilometres = astronomicalUnitsToParsecs * parsecsToKilometres
        astronomicalUnitsToLightYears = astronomicalUnitsToParsecs * parsecsToLightYears

        // From light years
        lightYearsToParsecs = 1 / parsecsToLightYears
        lightYearsToKilometres = lightYearsToParsecs * parsecsToKilometres
        LightYearsToAstronomicalUnits = lightYearsToParsecs * parsecsToAstronomicalUnits
    }


    func fromParsecs(distance: Double) -> [Double] {
        var conversions = [Double]()
        let kilometres = distance * parsecsToKilometres
        conversions.append(kilometres)
        let astrononmicalUnits = distance * parsecsToAstronomicalUnits
        conversions.append(astrononmicalUnits)
        let lightYears = distance * parsecsToLightYears
        conversions.append(lightYears)
        return conversions
    }

    func fromKilometres(distance: Double) -> [Double] {
        var conversions = [Double]()
        let astrononmicalUnits = distance * kilometresToAstronomicalUnits
        conversions.append(astrononmicalUnits)
        let lightYears = distance * kilometresToLightYears
        conversions.append(lightYears)
        let parsecs = distance * kilometresToParsecs
        conversions.append(parsecs)
        return conversions
    }

    func fromAstronomicalUnits(distance: Double) -> [Double] {
        var conversions = [Double]()
        let lightYears = distance * astronomicalUnitsToLightYears
        conversions.append(lightYears)
        let parsecs = distance * astronomicalUnitsToParsecs
        conversions.append(parsecs)
        let kilometres = distance * astronomicalUnitsToKilometres
        conversions.append(kilometres)
        return conversions
    }

    func fromLightYears(distance: Double) -> [Double] {
        var conversions = [Double]()
        let parsecs = distance * lightYearsToParsecs
        conversions.append(parsecs)
        let kilometres = distance * lightYearsToKilometres
        conversions.append(kilometres)
        let astronomicalUnits = distance * LightYearsToAstronomicalUnits
        conversions.append(astronomicalUnits)
        return conversions
    }
}
