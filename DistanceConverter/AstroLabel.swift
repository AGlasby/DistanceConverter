//
//  AstroLabel.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 03/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit

class AstroLabel: UILabel {

    let topInset = CGFloat(6.0), bottomInset = CGFloat(6.0), leftInset = CGFloat(6.0), rightInset = CGFloat(6.0)


    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        clipsToBounds = true
        textColor = UIColor(colorLiteralRed: 0.004, green: 0.055, blue: 0.129, alpha: 1.00)
    }


    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }


    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }


    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

}
