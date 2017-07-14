//
//  RHSCLogonTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2017-07-13.
//  Copyright © 2017 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

protocol logonButtonDelegateProtocol {
    
    func didClickOnLogonButton(_ sender: RHSCLogonTableViewCell?)
    
}

open class RHSCLogonTableViewCell : UITableViewCell {
    @IBOutlet weak var buttonField: UIButton!
    var delegate: logonButtonDelegateProtocol? = nil
    
    func configure(_ sender: logonButtonDelegateProtocol?) {
        delegate = sender
    }
    
    @IBAction func buttonClicked(_ sender: AnyObject?) {
        delegate?.didClickOnLogonButton(self)
    }
}
