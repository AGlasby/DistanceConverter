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
    @IBOutlet weak var backgroundImageViewTop: UIImageView!
    
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
    var selectedBackground = Int()
    var backgrounds = [UIImage]()


    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSegmentedControl()
        setUpLabels()
        changeLabels(selectedSegment: 0)
        distanceInputTextField.text = "0"
        distanceInputTextField.addDoneButtonOnKeyboard(textField: distanceInputTextField)
        distanceInputTextField.becomeFirstResponder()
        setUpBackgroundImages()
        updateOutput()
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
        self.backgroundImageViewTop.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.backgroundImageViewTop.addGestureRecognizer(swipeLeft)
    }


    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        var direction = String()
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                direction = "Right"
                if selectedBackground == 3 {
                    selectedBackground = 0
                } else {
                    selectedBackground += 1
                }
                    backgroundImageViewTop.frame.origin.x -= backgroundImageViewTop.frame.width
            case UISwipeGestureRecognizerDirection.left:
                direction = "Left"
                if selectedBackground == 0 {
                    selectedBackground = 3
                } else {
                    selectedBackground -= 1
                }
                    backgroundImageViewTop.frame.origin.x += backgroundImageViewTop.frame.width
            default:
                break
            }
        }
        backgroundImageViewTop.image = backgrounds[selectedBackground]
        if direction == "Right" {
            animateBackgroundChange(direction: "Right")
        } else {
            animateBackgroundChange(direction: "Left")
        }
        setUpSwipeGestureRecognizers()
    }


    func setUpBackgroundImages() {
        backgrounds.append(#imageLiteral(resourceName: "universe1small"))
        backgrounds.append(#imageLiteral(resourceName: "universe2small"))
        backgrounds.append(#imageLiteral(resourceName: "universe3small"))
        backgrounds.append(#imageLiteral(resourceName: "universe4small"))
        selectedBackground = Int(arc4random_uniform(3))
        backgroundImageView.image = backgrounds[selectedBackground]
        setUpSwipeGestureRecognizers()
    }

    
    func animateBackgroundChange(direction: String) {
        UIView.animate(withDuration: 0.7, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            if direction == "Right"{
                var backgroundLeftFrame = self.backgroundImageViewTop.frame
                backgroundLeftFrame.origin.x -= backgroundLeftFrame.size.width

                var backgroundRightFrame = self.backgroundImageViewTop.frame
                backgroundRightFrame.origin.x += backgroundRightFrame.size.width

                self.backgroundImageViewTop.frame = backgroundLeftFrame
                self.backgroundImageViewTop.frame = backgroundRightFrame
            } else {
                var backgroundRightFrame = self.backgroundImageViewTop.frame
                backgroundRightFrame.origin.x += backgroundRightFrame.size.width * 2

                var backgroundLeftFrame = self.backgroundImageViewTop.frame
                backgroundLeftFrame.origin.x -= backgroundLeftFrame.size.width

                self.backgroundImageViewTop.frame = backgroundRightFrame
                self.backgroundImageViewTop.frame = backgroundLeftFrame
            }
        }, completion: { finished in
            self.backgroundImageView.image = self.backgroundImageViewTop.image
        })
    }


    func displayDistance(distance: String, unit: String) {
        showAlert(title: "Distance", message: "That is \(distance) \(unit)")
    }


    func updateOutput() {
        let sourceUnitIndex = unitsSegmentedControl.selectedSegmentIndex
        var results = [Double]()
        if let distanceInput = distanceInputTextField.text{
            if distanceInput != "" {
                switch sourceUnitIndex {
                case 0:
                    results = astroConverter.fromParsecs(distance: Double(distanceInput)!)
                case 1:
                    results = astroConverter.fromKilometres(distance: Double(distanceInput)!)
                case 2:
                    results = astroConverter.fromAstronomicalUnits(distance: Double(distanceInput)!)
                case 3:
                    results = astroConverter.fromLightYears(distance: Double(distanceInput)!)
                default:
                    break
                }
                distanceResults.removeAll()
                for r in 0 ..< results.count {
                    distanceResults.append(results[r])
                    outputLabels[r].text = convertToScientific(distance: distanceResults[r])
                }
            return
        }
            showAlert(title: "Error", message: "Distance input field is not valid. Please enter non-negative number and try again.")
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
                distanceInputTextField.resignFirstResponder()
                updateOutput()
            } else {
                showAlert(title: "Incorrect input", message: "Distance entered must be 0 or greater.")
            }
        } else {
            showAlert(title: "Incorrect input", message: "Distance input field is not valid. Please enter non-negative number and try again.")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWikiPage" {
            let destinationVC = segue.destination as? WikiViewController
            destinationVC?.url = url
        }
    }
}

