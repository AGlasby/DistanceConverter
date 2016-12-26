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
    @IBOutlet weak var backgroundImageViewTop: backgroundImageView!
    
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
    var selectedLanguage:String = ""
    var languageForUrls = LanguageStruct()
    var wikiUrls: wikiPageUrlsForLanguage!


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        setUpLabels()
        setUpTextField()
        setUpUrlsForWikiLinks()
        setUpBackground()
        updateOutput()
    }

    func setUpBackground() {
        backgroundImageViewTop.setUpBackgroundImages(bottomImage: backgroundImageView)
    }


    override func viewWillAppear(_ animated: Bool) {
        distanceInputTextField.resignFirstResponder()
    }


    func setUpUrlsForWikiLinks() {
        if let userLanguage = languageForUrls.getLanguage() {
            selectedLanguage = userLanguage
        } else {
            selectedLanguage = "en"
        }
        wikiUrls = languageForUrls.buildUrlsForLanguage(languageISOCode: selectedLanguage)
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
            url = wikiUrls.parsecUrl
        case 1:
            url = wikiUrls.kilometreUrl
        case 2:
            url = wikiUrls.astronomicalUnitUrl
        default:
            url = wikiUrls.lightYearsUrl
        }

        performSegue(withIdentifier: "showWikiPage", sender: self)
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
        changeLabels(selectedSegment: 0)
    }


    func setUpTapGestures() {
        var taps = [AFGTapGestureRecognizer]()
        taps.append(AFGTapGestureRecognizer(target: self, action: #selector(tapGestureFunction)))
        taps.append(AFGTapGestureRecognizer(target: self, action: #selector(tapGestureFunction)))
        taps.append(AFGTapGestureRecognizer(target: self, action: #selector(tapGestureFunction)))
        for t in 0 ..< taps.count{
            taps[t].label = t + 1
            outputLabels[t].isUserInteractionEnabled = true
            outputLabels[t].addGestureRecognizer(taps[t])
        }
    }


    func tapGestureFunction(sender:AFGTapGestureRecognizer) {
        updateOutput()
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


    func setUpTextField() {
        distanceInputTextField.text = "12"
        distanceInputTextField.addDoneButtonOnKeyboard(textField: distanceInputTextField)
        distanceInputTextField.becomeFirstResponder()
    }


    func displayDistance(distance: String, unit: String) {
        showAlert(title: "Distance", message: "That is \(distance) \(unit)", viewController: self)
    }


    func updateOutput() {
        let sourceUnitIndex = unitsSegmentedControl.selectedSegmentIndex
        var results = [Double]()
        let distanceInput = convertToDouble(inputText: distanceInputTextField.text!)
            if distanceInput >= 0 {
                switch sourceUnitIndex {
                case 0:
                        results = astroConverter.fromParsecs(distance: distanceInput)
                case 1:
                        results = astroConverter.fromKilometres(distance: distanceInput)

                case 2:
                        results = astroConverter.fromAstronomicalUnits(distance: distanceInput)
                case 3:
                        results = astroConverter.fromLightYears(distance: distanceInput)
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
        showAlert(title: "Error", message: "Distance input field is not valid. Please enter non-zero number and try again.", viewController: self)
    }


    @IBAction func unitsSegmentedControl(_ sender: Any) {
        let segment = unitsSegmentedControl.selectedSegmentIndex
        changeLabels(selectedSegment: segment)
        updateOutput()
    }


    func changeLabels(selectedSegment: Int) {
        inputUnitLabel.text = labelSetUp[selectedSegment]["inputUnitLabel"]
        unit1Label.text = labelSetUp[selectedSegment]["unit1Label"]
        unit2Label.text = labelSetUp[selectedSegment]["unit2Label"]
        unit3Label.text = labelSetUp[selectedSegment]["unit3Label"]
    }


    @IBAction func convertDistanceTapped(_ sender: Any) {
        if let inputDistance = distanceInputTextField.text {
            let distanceInput = convertToDouble(inputText: inputDistance)
            if distanceInput > 0 {
                distanceInputTextField.resignFirstResponder()
                updateOutput()
                return
            }
        }
        showAlert(title: "Incorrect input", message: "Distance input field is not valid. Please enter non-zero number and try again.", viewController: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWikiPage" {
            let destinationVC = segue.destination as? WikiViewController
            destinationVC?.url = url
            destinationVC?.transitioningDelegate = self
        }
    }
}


extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AFGFadeInAnimator()
    }
}

