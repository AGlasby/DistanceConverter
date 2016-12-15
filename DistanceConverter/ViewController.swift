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
    @IBOutlet weak var unitsSegmentedControl: AstroSegmentedControl!

    @IBOutlet weak var distanceInputTextField: AstroTextField!
    @IBOutlet weak var inputUnitLabel: UILabel!

    @IBOutlet weak var convertButton: AstroButton!

    @IBOutlet weak var unit1OutputLabel: UILabel!
    @IBOutlet weak var unit1Label: UILabel!

    @IBOutlet weak var unit2OutputLabel: UILabel!
    @IBOutlet weak var unit2Label: UILabel!

    @IBOutlet weak var unit3OutputLabel: UILabel!
    @IBOutlet weak var unit3Label: UILabel!

    var distanceResults = [Double]()

    var url:String = ""
    var labelSetUp = [[String: String]]()
    var outputLabels = [UILabel]()

    var astroConverter = AstroDistance()


    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSegmentedControl()
        setUpLabels()
        changeLabels(selectedSegment: 0)

        distanceInputTextField.text = "0"
        distanceInputTextField.addDoneButtonOnKeyboard(textField: distanceInputTextField)
        distanceInputTextField.becomeFirstResponder()

        setUpSwipeGestureRecognizers()
    }


    func setUpSegmentedControl() {
        unitsSegmentedControl.setImagesForSegmentedControl()
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPressFunction))
        unitsSegmentedControl.addGestureRecognizer(lpgr)
        lpgr.minimumPressDuration = 1
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
        case 1:
            url = BASEURL + KILOMETRE
        case 2:
            url = BASEURL + ASTRONOMICALUNIT
        default:
            url = BASEURL + LIGHTYEAR
        }
        performSegue(withIdentifier: "showWikiPage", sender: self)
        return
    }
    

    func setUpLabels() {

        var labels = [String: String]()
        labels["inputUnitLabel"] = "parsecs"
        labels["unit1Label"] = "kilometres"
        labels["unit2Label"] = "astronomical units"
        labels["unit3Label"] = "light years"
        labelSetUp.append(labels)

        labels.removeAll()
        labels["inputUnitLabel"] = "kilometres"
        labels["unit1Label"] = "parsecs"
        labels["unit2Label"] = "astronomical units"
        labels["unit3Label"] = "light years"
        labelSetUp.append(labels)

        labels.removeAll()
        labels["inputUnitLabel"] = "astronomical units"
        labels["unit1Label"] = "parsecs"
        labels["unit2Label"] = "kilometres"
        labels["unit3Label"] = "light years"
        labelSetUp.append(labels)

        labels.removeAll()
        labels["inputUnitLabel"] = "light years"
        labels["unit1Label"] = "parsecs"
        labels["unit2Label"] = "kilometres"
        labels["unit3Label"] = "astronomical units"
        labelSetUp.append(labels)

        outputLabels.append(unit1OutputLabel)
        outputLabels.append(unit2OutputLabel)
        outputLabels.append(unit3OutputLabel)
        
        setUpTapGestures()
    }


    func setUpTapGestures() {
        var taps = [AGTapGestureRecognizer]()
        taps.append(AGTapGestureRecognizer(target: self, action: #selector(tapFunction)))
        taps.append(AGTapGestureRecognizer(target: self, action: #selector(tapFunction)))
        taps.append(AGTapGestureRecognizer(target: self, action: #selector(tapFunction)))
        setTapGestures(tap: taps)
    }


    func setTapGestures(tap: [AGTapGestureRecognizer]) {
        for t in 0 ..< tap.count {
            tap[t].label = t + 1
            outputLabels[t].isUserInteractionEnabled = true
            outputLabels[t].addGestureRecognizer(tap[t])
        }
    }


    func tapFunction(sender:AGTapGestureRecognizer) {
        let tap = sender.label! as Int
        switch tap {
        case 1:
            let unitStr = convertToDecimalString(distance: distanceResults[0])
            displayDistance(distance: unitStr, unit: unit1Label.text!)
        case 2:
            let unitStr = convertToDecimalString(distance: distanceResults[1])
            displayDistance(distance: unitStr, unit: unit2Label.text!)
        default:
            let unitStr = convertToDecimalString(distance: distanceResults[2])
            displayDistance(distance: unitStr, unit: unit3Label.text!)
        }
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
    

    func displayDistance(distance: String, unit: String) {
        let alert = UIAlertController(title: "Distance", message: "That is \(distance) \(unit)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    func updateOutput() {
        let sourceUnitIndex = unitsSegmentedControl.selectedSegmentIndex
        var results = [Double]()

        switch sourceUnitIndex {
        case 0:
            results = astroConverter.fromParsecs(distance: Double(distanceInputTextField.text!)!)
        case 1:
            results = astroConverter.fromKilometres(distance: Double(distanceInputTextField.text!)!)
        case 2:
            results = astroConverter.fromAstronomicalUnits(distance: Double(distanceInputTextField.text!)!)
        case 3:
            results = astroConverter.fromLightYears(distance: Double(distanceInputTextField.text!)!)
        default:
            break
        }
        
        distanceResults.removeAll()
        for r in 0 ..< results.count {
            distanceResults.append(results[r])
            outputLabels[r].text = convertToScientific(distance: distanceResults[r])
        }
    }


    @IBAction func unitsSegmentedControl(_ sender: Any) {

        let segment = unitsSegmentedControl.selectedSegmentIndex
        switch segment {
        case 0:
            changeLabels(selectedSegment: segment)
        case 1:
            changeLabels(selectedSegment: segment)
        case 2:
            changeLabels(selectedSegment: segment)
        case 3:
            changeLabels(selectedSegment: segment)
        default: break

        }
        updateOutput()
    }


    func changeLabels(selectedSegment: Int) {
        inputUnitLabel.text = labelSetUp[selectedSegment]["inputUnitLabel"]
        unit1Label.text = labelSetUp[selectedSegment]["unit1Label"]
        unit2Label.text = labelSetUp[selectedSegment]["unit2Label"]
        unit3Label.text = labelSetUp[selectedSegment]["unit3Label"]
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

