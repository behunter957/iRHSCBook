//
//  RHSCPickerTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

public class RHSCPickerTableViewCell : UITableViewCell,UIPickerViewDataSource,UIPickerViewDelegate {
//    @IBOutlet weak var typePicker : UIPickerView? = nil
    @IBOutlet weak var eventType: UITextField? = nil

    var typeList = ["Friendly","Lesson","MNHL","Ladder","Tournament"]

    public func configure() {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.eventType!.inputView = picker
    }

    public func configure(event: String) {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.eventType!.inputView = picker
        self.eventType!.text = event
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.typeList.count
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.typeList[row]
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.eventType!.text = self.typeList[row]
        self.eventType?.resignFirstResponder()
    }
    
}
