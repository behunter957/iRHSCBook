//
//  RHSCGuestDetailsViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-30.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

protocol setGuestProtocol {

    func setGuest(guest:RHSCGuest?,  number:UInt16)

}

class RHSCGuestDetailsViewController : UIViewController {

    var guestNumber : UInt16 = 0
    
    var guest : RHSCGuest? = nil
    
    @IBOutlet weak var guestNameField : UITextField? = nil
    @IBOutlet weak var guestEmailField : UITextField? = nil
    @IBOutlet weak var guestPhoneField : UITextField? = nil
    
    var delegate : AnyObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.guestNameField!.text = self.guest!.name
        self.guestEmailField!.text = self.guest!.email
        self.guestPhoneField!.text = self.guest!.phone
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func done() {
        if self.guestNameField?.text?.characters.count > 5 {
            self.guest!.name = self.guestNameField!.text!
            self.guest!.email = self.guestEmailField!.text!
            self.guest!.phone = self.guestPhoneField!.text!
            if delegate is RHSCBookCourtViewController {
                let deltarget = (delegate as! RHSCBookCourtViewController)
                deltarget.setGuest(self.guest, number: self.guestNumber)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func clear() {
        self.guestNameField!.text = ""
        self.guestEmailField!.text = ""
        self.guestPhoneField!.text = ""
    }

}
