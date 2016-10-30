//
//  RHSCButtonTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

protocol playerButtonDelegateProtocol {
    
    func didClickOnPlayerButton(_ sender: RHSCButtonTableViewCell?, buttonIndex: Int)
    
}

open class RHSCButtonTableViewCell : UITableViewCell {
    @IBOutlet weak var buttonField: UIButton!
    var delegate: playerButtonDelegateProtocol? = nil
    var buttonNum: Int = 0
    
    func configure(_ sender: playerButtonDelegateProtocol?, buttonNum: Int, buttonText: String?) {
        delegate = sender
        self.buttonNum = buttonNum
        if let targText = buttonText {
            let aText = NSAttributedString.init(string: targText)
            buttonField.setAttributedTitle(aText, for: UIControlState())
            buttonField.contentHorizontalAlignment = .right
        }
    }
    
    func updateButtonText(_ buttonText: String) {
        let aText = NSAttributedString.init(string: buttonText)
        buttonField.setAttributedTitle(aText, for: UIControlState())
        buttonField.contentHorizontalAlignment = .right
    }
    
    @IBAction func buttonClicked(_ sender: AnyObject?) {
        delegate?.didClickOnPlayerButton(self, buttonIndex: buttonNum)
    }
}
