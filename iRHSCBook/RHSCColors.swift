//
//  RHSCColors.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-03.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//
// green: (available)  #A4FF98 (164,255,152)
// yellow: (lesson/clinic)  #FEFC70 (254,252,112)
// purple: (MNHL, LADDER, T&D, etc)  #DCA4FF (220,164,255)
// blue: booked  #A4E9FF ( 164, 233, 255)
//
// history:
// light brown - completed  #EBD17E (235,209,126)
// light red - no show  #FF8B7B (255,139,123)

import Foundation

import UIKit

extension UIColor {
    // Local Palette
    class func availableGreen() -> UIColor {
        return UIColor(colorLiteralRed: 164.0, green: 255.0, blue: 152.0, alpha: 1.0)
    }
    
    class func lessonYellow() -> UIColor {
        return UIColor(colorLiteralRed: 254.0, green: 252.0, blue: 112.0, alpha: 1.0)
    }
    
    class func leaguePurple() -> UIColor {
        return UIColor(colorLiteralRed: 220.0, green: 164.0, blue: 255.0, alpha: 1.0)
    }
    
    class func bookedBlue() -> UIColor {
        return UIColor(colorLiteralRed: 164.0, green: 233.0, blue: 255.0, alpha: 1.0)
    }
    
    class func historyBrown() -> UIColor {
        return UIColor(colorLiteralRed: 235.0, green: 209.0, blue: 126.0, alpha: 1.0)
    }
    
    class func noshowRed() -> UIColor {
        return UIColor(colorLiteralRed: 255.0, green: 139.0, blue: 123.0, alpha: 1.0)
    }
    
    // Global Function
//    class func primaryColor() -> UIColor { return ralphRed() }
}