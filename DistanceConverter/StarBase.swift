//
//  StarBase.swift
//  12parsecs
//
//  Created by Alan Glasby on 26/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import Foundation

struct  StarStruct {
    var nameOfStar: String
    var spectralType: SpectralTypes
    var magnitude: Double
}

enum SpectralTypes {
    case O, B, A, F, G, K, M, R, N, S, D, m}

var spectralTypesA: Set = ["B", "G", "K", "D"]
var spectralTypesAn: Set = ["O", "A", "F", "M", "N", "S", "m"]

struct StarBase {

    var starDatabase = [StarStruct]()

    var star: StarStruct = StarStruct(nameOfStar: "", spectralType: SpectralTypes.O, magnitude: 0.00)

    mutating func buildDatabase() {
        star.nameOfStar = "NN3331"
        star.spectralType = SpectralTypes.M
        star.magnitude = 9.885390462
        starDatabase.append(star)

        star.nameOfStar = "NN3332B"
        star.spectralType = SpectralTypes.M
        star.magnitude = 11.25539046
        starDatabase.append(star)

        star.nameOfStar = "GL1140"
        star.spectralType = SpectralTypes.D
        star.magnitude = 13.91322501
        starDatabase.append(star)

        star.nameOfStar = "NN3727"
        star.spectralType = SpectralTypes.M
        star.magnitude = 10.55539046
        starDatabase.append(star)

        star.nameOfStar = "GJ1179 B"
        star.spectralType = SpectralTypes.D
        star.magnitude = 15.25583025
        starDatabase.append(star)

    }


    func getStar(distance: Double) -> StarStruct {
        let ind = Int(arc4random_uniform(UInt32(starDatabase.count)))
        let starDetails = starDatabase[ind]
        return starDetails
    }
}
