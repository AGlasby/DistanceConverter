//
//  ViewController.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 30/11/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!

    @IBOutlet weak var distanceInputTextField: UITextField!
    @IBOutlet weak var inputUnitLabel: UILabel!

    @IBOutlet weak var convertButton: AstroButton!

    @IBOutlet weak var unit1OutputLabel: UILabel!
    @IBOutlet weak var unit1Label: UILabel!

    @IBOutlet weak var unit2OutputLabel: UILabel!
    @IBOutlet weak var unit2Label: UILabel!

    @IBOutlet weak var unit3OutputLabel: UILabel!
    @IBOutlet weak var unit3Label: UILabel!

//  From parsecs
    let kmParsecConversionFactor = 3.08567758149137e13 //per parsec
    let auParsecConversionFactor = 2.0626481e5 //per parsec
    let lyParsecConversionFactor = 3.2615638 //per parsec

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

    var distanceResult1:Double!
    var distanceResult2:Double!
    var distanceResult3:Double!

    var url:String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConversionFactors()

        distanceInputTextField.text = "0"
        inputUnitLabel.text = "parsecs"
        unit1Label.text = "kilometres"
        unit2Label.text = "astronomical units"
        unit3Label.text = "light years"

        setUpTapGestures()

        addDoneButtonOnKeyboard()
        distanceInputTextField.becomeFirstResponder()

        setUpSegmentedControl()
        setUpSwipeGestureRecognizers()
    }


    func setUpConversionFactors() {
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
    }


    func setUpTapGestures() {
        let tap1 = AGTapGestureRecognizer(target: self, action: #selector(tapFunction))
        tap1.label = 1
        unit1OutputLabel.isUserInteractionEnabled = true
        unit1OutputLabel.addGestureRecognizer(tap1)

        let tap2 = AGTapGestureRecognizer(target: self, action: #selector(tapFunction))
        tap2.label = 2
        unit2OutputLabel.isUserInteractionEnabled = true
        unit2OutputLabel.addGestureRecognizer(tap2)

        let tap3 = AGTapGestureRecognizer(target: self, action: #selector(tapFunction))
        tap3.label = 3
        unit3OutputLabel.isUserInteractionEnabled = true
        unit3OutputLabel.addGestureRecognizer(tap3)
    }


    func tapFunction(sender:AGTapGestureRecognizer) {
        let tap = sender.label! as Int
        switch tap {
        case 1:
            let unitStr = convertToDecimalString(distance: distanceResult1)
            displayDistance(distance: unitStr, unit: unit1Label.text!)
        case 2:
            let unitStr = convertToDecimalString(distance: distanceResult2)
            displayDistance(distance: unitStr, unit: unit2Label.text!)
        default:
            let unitStr = convertToDecimalString(distance: distanceResult3)
            displayDistance(distance: unitStr, unit: unit3Label.text!)
        }
    }


    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.doneButtonAction))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.distanceInputTextField.inputAccessoryView = doneToolbar
    }


    func doneButtonAction() {
        self.distanceInputTextField.resignFirstResponder()
    }


    func setUpSegmentedControl() {
        setImagesForSegmentedControl()
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPressFunction))
        unitsSegmentedControl.addGestureRecognizer(lpgr)
        lpgr.minimumPressDuration = 1
    }


    func setImagesForSegmentedControl() {
        let image1 = UIImage(named: "parsecs.png")?.withRenderingMode(.alwaysOriginal)
        self.unitsSegmentedControl.setImage(image1, forSegmentAt: 0)
        let image2 = UIImage(named: "kilometres.png")?.withRenderingMode(.alwaysOriginal)
        self.unitsSegmentedControl.setImage(image2, forSegmentAt: 1)
        let image3 = UIImage(named: "astronomical units.png")?.withRenderingMode(.alwaysOriginal)
        self.unitsSegmentedControl.setImage(image3, forSegmentAt: 2)
        let image4 = UIImage(named: "light years.png")?.withRenderingMode(.alwaysOriginal)
        self.unitsSegmentedControl.setImage(image4, forSegmentAt: 3)
    }


    func longPressFunction(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.ended {
            return
        }
        var p = CGPoint()
        p = gestureRecognizer.location(in: unitsSegmentedControl)
        let r = unitsSegmentedControl.frame.width
        let index = Int(ceil(p.x/(r/4))) - 1
        switch index {
        case 0:
            url = BASEURL + PARSEC
            performSegue(withIdentifier: "showWikiPage", sender: self)
        case 1:
            url = BASEURL + KILOMETRE
            performSegue(withIdentifier: "showWikiPage", sender: self)
        case 2:
            url = BASEURL + ASTRONOMICALUNIT
            performSegue(withIdentifier: "showWikiPage", sender: self)
        default:
            url = BASEURL + LIGHTYEAR
            performSegue(withIdentifier: "showWikiPage", sender: self)
        }

        return
    }


    func setUpSwipeGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.backgroundImageView.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.backgroundImageView.addGestureRecognizer(swipeLeft)
    }


    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            default:
                break
            }
        }
    }
    

    func convertToScientific(distance: Double) -> String {
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


    func displayDistance(distance: String, unit: String) {
        let alert = UIAlertController(title: "Distance", message: "That is \(distance) \(unit)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    func updateOutput() {
        distanceResult1 = Double(distanceInputTextField.text!)! * conversionFactors[unit1Label.text!]!
        unit1OutputLabel.text = convertToScientific(distance: distanceResult1)
        distanceResult2 = Double(distanceInputTextField.text!)! * conversionFactors[unit2Label.text!]!
        unit2OutputLabel.text = convertToScientific(distance: distanceResult2)
        distanceResult3 = Double(distanceInputTextField.text!)! * conversionFactors[unit3Label.text!]!
        unit3OutputLabel.text = convertToScientific(distance: distanceResult3)
    }


    @IBAction func unitsSegmentedControl(_ sender: Any) {
        
        switch unitsSegmentedControl.selectedSegmentIndex {
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
        if let distanceInput = Double(distanceInputTextField.text!) {
            if distanceInput >= 0 {
                updateOutput()
            } else {
                let alert = UIAlertController(title: "Incorrect input", message: "Distance entered must be 0 or greater.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Incorrect input", message: "Distance entered must be a non-negative number.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWikiPage" {
            let destinationVC = segue.destination as? WikiViewController
            destinationVC?.url = url
        }
    }
}

