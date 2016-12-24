//
//  backgroundImageView.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 21/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit

class backgroundImageView: UIImageView {

    var selectedBackground = Int()
    var backgrounds = [UIImage]()
    var bottomImageView: UIImageView!

    func setUpBackgroundImages(bottomImage: UIImageView) {
        bottomImageView = bottomImage
        backgrounds.append(#imageLiteral(resourceName: "universe1small"))
        backgrounds.append(#imageLiteral(resourceName: "universe2small"))
        backgrounds.append(#imageLiteral(resourceName: "universe3small"))
        backgrounds.append(#imageLiteral(resourceName: "universe4small"))
        selectedBackground = Int(arc4random_uniform(3))
        bottomImageView.image = backgrounds[selectedBackground]
        setUpSwipeGestureRecognizers()
    }


    func animateBackgroundChange(direction: String) {
        UIView.animate(withDuration: 0.7, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            if direction == "Right"{
                var backgroundLeftFrame = self.frame
                backgroundLeftFrame.origin.x -= backgroundLeftFrame.size.width

                var backgroundRightFrame = self.frame
                backgroundRightFrame.origin.x += backgroundRightFrame.size.width

                self.frame = backgroundLeftFrame
                self.frame = backgroundRightFrame
            } else {
                var backgroundRightFrame = self.frame
                backgroundRightFrame.origin.x += backgroundRightFrame.size.width * 2

                var backgroundLeftFrame = self.frame
                backgroundLeftFrame.origin.x -= backgroundLeftFrame.size.width

                self.frame = backgroundRightFrame
                self.frame = backgroundLeftFrame
            }
        }, completion: { finished in
            self.bottomImageView.image = self.image
        })
    }
    

    func setUpSwipeGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
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
                self.frame.origin.x -= self.frame.width
            case UISwipeGestureRecognizerDirection.left:
                direction = "Left"
                if selectedBackground == 0 {
                    selectedBackground = 3
                } else {
                    selectedBackground -= 1
                }
                self.frame.origin.x += self.frame.width
            default:
                break
            }
        }
        self.image = backgrounds[selectedBackground]
        if direction == "Right" {
            animateBackgroundChange(direction: "Right")
        } else {
            animateBackgroundChange(direction: "Left")
        }
        setUpSwipeGestureRecognizers()
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
