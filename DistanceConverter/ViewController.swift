//
//  ViewController.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 30/11/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var unitsSegemnentedControl: UISegmentedControl!

    @IBOutlet weak var distanceInputTextField: UITextField!
    @IBOutlet weak var inputUnitLabel: UILabel!

    @IBOutlet weak var unit1OutputLabel: UILabel!
    @IBOutlet weak var unit1Label: UILabel!

    @IBOutlet weak var unit2OutputLabel: UILabel!
    @IBOutlet weak var unit2Label: UILabel!

    @IBOutlet weak var unit3OutputLabel: UILabel!
    @IBOutlet weak var unit3Label: UILabel!

//  From parsecs
    let kmParsecConversionFactor = 3.086e13 //per parsec
    let auParsecConversionFactor = 2.06265e5 //per parsec
    let lyParsecConversionFactor = 3.26165 //per parsec

    var parsecKmConversionFactor:Double!
    var auKmConversionFactor:Double!
    var lyKmConversionFactor:Double!

    var parsecAuConversionFactor:Double!
    var kmAuConversionFactor:Double!
    var lyAuConversionFactor:Double!

    var parsecLyConversionFactor:Double!
    var kmLyConversionFactor:Double!
    var auLyConversionFactor:Double!

    var conversionFactors = [String: Double]()


    override func viewDidLoad() {
        super.viewDidLoad()

        //  From kilometres
        parsecKmConversionFactor = 1 / kmParsecConversionFactor
        auKmConversionFactor = parsecKmConversionFactor * auParsecConversionFactor
        lyKmConversionFactor = parsecKmConversionFactor * lyParsecConversionFactor

        // From astronomical units
        parsecAuConversionFactor = 1 / auParsecConversionFactor
        kmAuConversionFactor = parsecAuConversionFactor * kmParsecConversionFactor
        lyAuConversionFactor = parsecAuConversionFactor * lyParsecConversionFactor

        // From light years
        parsecLyConversionFactor = 1 / lyParsecConversionFactor
        kmLyConversionFactor = parsecLyConversionFactor * kmParsecConversionFactor
        auLyConversionFactor = parsecLyConversionFactor * auParsecConversionFactor

        conversionFactors["parsecs"] = 1.0
        conversionFactors["kilometres"] = kmParsecConversionFactor
        conversionFactors["astronomical units"] = auParsecConversionFactor
        conversionFactors["light years"] = lyParsecConversionFactor

        distanceInputTextField.text = "0"
        inputUnitLabel.text = "parsecs"
        unit1Label.text = "kilometres"
        unit2Label.text = "astronomical units"
        unit3Label.text = "light years"
    }


    func convertToScientifc(distance: Double) -> String {
        let distanceNSNumber = NSNumber(value: Double(distance))
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.scientific
        formatter.positiveFormat = "0.#####E+0"
        formatter.exponentSymbol = "e"
        if let stringFromNumber = formatter.string(from: distanceNSNumber) {
            return stringFromNumber
        } else {
            return "Error"
        }
    }


    func updateOutput() {
        unit1OutputLabel.text = convertToScientifc(distance: Double(distanceInputTextField.text!)! * conversionFactors[unit1Label.text!]!)
        unit2OutputLabel.text = convertToScientifc(distance: Double(distanceInputTextField.text!)! * conversionFactors[unit2Label.text!]!)
        unit3OutputLabel.text = convertToScientifc(distance: Double(distanceInputTextField.text!)! * conversionFactors[unit3Label.text!]!)
    }


    @IBAction func unitsSegmentedControl(_ sender: Any) {
        
        switch unitsSegemnentedControl.selectedSegmentIndex {
        case 0:
            inputUnitLabel.text = "parsecs"
            unit1Label.text = "kilometres"
            unit2Label.text = "astronomical units"
            unit3Label.text = "light years"
            conversionFactors["parsecs"] = 1.0
            conversionFactors["kilometres"] = kmParsecConversionFactor
            conversionFactors["astronomical units"] = auParsecConversionFactor
            conversionFactors["light years"] = lyParsecConversionFactor
        case 1:
            inputUnitLabel.text = "kilometres"
            unit1Label.text = "parsecs"
            unit2Label.text = "astronomical units"
            unit3Label.text = "light years"
            conversionFactors["parsecs"] = parsecKmConversionFactor
            conversionFactors["kilometres"] = 1.0
            conversionFactors["astronomical units"] = auKmConversionFactor
            conversionFactors["light years"] = lyKmConversionFactor
        case 2:
            inputUnitLabel.text = "astronomical units"
            unit1Label.text = "parsecs"
            unit2Label.text = "kilometres"
            unit3Label.text = "light years"
            conversionFactors["parsecs"] = parsecAuConversionFactor
            conversionFactors["kilometres"] = kmAuConversionFactor
            conversionFactors["astronomical units"] = 1.0
            conversionFactors["light years"] = lyAuConversionFactor
        default:
            inputUnitLabel.text = "light years"
            unit1Label.text = "parsecs"
            unit2Label.text = "kilometres"
            unit3Label.text = "astronomical units"
            conversionFactors["parsecs"] = parsecLyConversionFactor
            conversionFactors["kilometres"] = kmLyConversionFactor
            conversionFactors["astronomical units"] = auLyConversionFactor
            conversionFactors["light years"] = 1.0
        }
        updateOutput()
    }


    @IBAction func convertDistanceTapped(_ sender: Any) {
        updateOutput()
    }
}

