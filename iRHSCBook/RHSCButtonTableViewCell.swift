//
//  RHSCButtonTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

protocol PlayerButtonDelegate {
    
    func didClickOnPlayerButton(sender: RHSCButtonTableViewCell?, buttonIndex: Int)
    
}

public class RHSCButtonTableViewCell : UITableViewCell {
    @IBOutlet weak var buttonField: UIButton!
    var delegate: PlayerButtonDelegate? = nil
    var buttonNum: Int = 0
    
    func configure(sender: PlayerButtonDelegate?, buttonNum: Int, buttonText: String?) {
        delegate = sender
        self.buttonNum = buttonNum
        if let targText = buttonText {
            let aText = NSAttributedString.init(string: targText)
            buttonField.setAttributedTitle(aText, forState: .Normal)
            buttonField.contentHorizontalAlignment = .Right
        }
    }
    
    func updateButtonText(buttonText: String) {
        let aText = NSAttributedString.init(string: buttonText)
        buttonField.setAttributedTitle(aText, forState: .Normal)
        buttonField.contentHorizontalAlignment = .Right
    }
    
    @IBAction func buttonClicked(sender: AnyObject?) {
        delegate?.didClickOnPlayerButton(self, buttonIndex: buttonNum)
    }
}
