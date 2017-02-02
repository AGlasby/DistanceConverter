//
//  AstroTextField.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 03/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit

class AstroTextField: UITextField, UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        clipsToBounds = true
        textColor = UIColor(colorLiteralRed: 0.004, green: 0.055, blue: 0.129, alpha: 1.00)
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: nil, action: #selector(self.doneButtonAction))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textField.inputAccessoryView = doneToolbar
    }


    func doneButtonAction() {
        self.resignFirstResponder()
    }
}
