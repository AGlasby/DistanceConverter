//
//  AstroSegmentedControl.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 03/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit

class AstroSegmentedControl: UISegmentedControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setImagesForSegmentedControl() {
        let image1 = UIImage(named: "parsecs.png")?.withRenderingMode(.alwaysOriginal)
        self.setImage(image1, forSegmentAt: 0)
        let image2 = UIImage(named: "kilometres.png")?.withRenderingMode(.alwaysOriginal)
        self.setImage(image2, forSegmentAt: 1)
        let image3 = UIImage(named: "astronomical units.png")?.withRenderingMode(.alwaysOriginal)
        self.setImage(image3, forSegmentAt: 2)
        let image4 = UIImage(named: "light years.png")?.withRenderingMode(.alwaysOriginal)
        self.setImage(image4, forSegmentAt: 3)
    }
}
