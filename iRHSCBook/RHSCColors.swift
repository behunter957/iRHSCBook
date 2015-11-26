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
        return UIColor(red:0.00, green:0.66, blue:0.09, alpha:1.0)
    }
    
    class func lessonYellow() -> UIColor {
        return UIColor(red:0.98, green:1.00, blue:0.00, alpha:1.0)
    }
    
    class func leaguePurple() -> UIColor {
        return UIColor(red:0.80, green:0.00, blue:1.00, alpha:1.0)
//        return UIColor(red:0.44, green:0.00, blue:1.00, alpha:1.0)
    }
    
    class func bookedBlue() -> UIColor {
        return UIColor(red:0.00, green:0.26, blue:0.79, alpha:1.0)
    }
    
    class func historyBrown() -> UIColor {
        return UIColor(red:0.92, green:0.82, blue:0.49, alpha:1.0)
    }
    
    class func noshowRed() -> UIColor {
        return UIColor(red:1.00, green:0.55, blue:0.48, alpha:1.0)
    }
    
    class func fieldBackground() -> UIColor {
        return UIColor(red:0.48, green:0.48, blue:0.48, alpha:1.0)
    }
    
    // Global Function
    //    class func primaryColor() -> UIColor { return ralphRed() }
}