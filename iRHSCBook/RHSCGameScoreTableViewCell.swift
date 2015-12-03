//
//  RHSCGameScoreTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-27.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

protocol scoreChangedProtocol {
    
    func scoreChanged()
}

public class RHSCGameScoreTableViewCell : UITableViewCell,UIPickerViewDataSource,UIPickerViewDelegate {
    //    @IBOutlet weak var typePicker : UIPickerView? = nil
    @IBOutlet weak var gameText: UILabel? = nil
    @IBOutlet weak var team1score: UITextField? = nil
    @IBOutlet weak var team2score: UITextField? = nil

    var delegate : scoreChangedProtocol? = nil

    var typeList = ["0","1","2","3","4","5","6","7","8","9",
        "10","11","12","13","14","15","16","17","18","19",
        "20","21","22","23","24","25"]
    
    var picker1 = UIPickerView()
    var picker2 = UIPickerView()
    
    public func configure(forGame: String) {
        self.gameText?.text = forGame
        picker1.dataSource = self
        picker1.delegate = self
        picker2.dataSource = self
        picker2.delegate = self
        self.team1score!.inputView = picker1
        self.team2score!.inputView = picker2
    }
    
    public func configure(forGame: String, scores: [String]) {
        self.gameText?.text = forGame
        picker1.dataSource = self
        picker1.delegate = self
        picker2.dataSource = self
        picker2.delegate = self
        self.team1score!.inputView = picker1
        self.team1score!.text = scores[0]
        self.team2score!.inputView = picker2
        self.team2score!.text = scores[1]
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
        if pickerView == picker1 {
            self.team1score!.text = self.typeList[row]
            self.team1score?.resignFirstResponder()
        }
        if pickerView == picker2 {
            self.team2score!.text = self.typeList[row]
            self.team2score?.resignFirstResponder()
        }
    }
    
    @IBAction func val1Changed(sender: AnyObject) {
        delegate!.scoreChanged()
    }
    
    @IBAction func val2Changed(sender: AnyObject) {
        delegate!.scoreChanged()
    }
    
    
}
