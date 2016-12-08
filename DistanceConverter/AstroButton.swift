//
//  AstroButton.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 03/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit

let SHADOW_COLOUR: CGFloat = 157.0 / 255.0

class AstroButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor(red: SHADOW_COLOUR, green: SHADOW_COLOUR, blue: SHADOW_COLOUR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width:0.00, height:2.00)
        setTitleColor(UIColor (colorLiteralRed: 0.004, green: 0.055, blue: 0.129, alpha: 1.00), for: .normal)
    }


    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
