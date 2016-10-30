//
//  RHSCPickerTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

open class RHSCPickerTableViewCell : UITableViewCell,UIPickerViewDataSource,UIPickerViewDelegate {
//    @IBOutlet weak var typePicker : UIPickerView? = nil
    @IBOutlet weak var eventType: UITextField? = nil

    var typeList = ["Friendly","Lesson","Practice","MNHL","Ladder","Tournament"]

    open func configure() {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.eventType!.inputView = picker
    }

    open func configure(_ event: String) {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.eventType!.inputView = picker
        self.eventType!.text = event
    }
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.typeList.count
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.typeList[row]
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.eventType!.text = self.typeList[row]
        self.eventType?.resignFirstResponder()
    }
    
}
