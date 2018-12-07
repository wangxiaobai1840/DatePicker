//
//  ViewController.swift
//  DatePicker
//
//  Created by WLX on 2018/12/6.
//  Copyright © 2018 WLX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let resultLabel:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    fileprivate func createUI(){
        resultLabel.frame = CGRect(x: (self.view.frame.size.width - 200)/2, y: 90, width: 200, height: 40)
        resultLabel.text = "选择时间"
        resultLabel.clipsToBounds = true
        resultLabel.layer.cornerRadius = 4
        resultLabel.layer.borderColor = UIColor.lightGray.cgColor
        resultLabel.textAlignment = .center
        resultLabel.layer.borderWidth = 0.5
        self.view.addSubview(resultLabel)
        
        let titleArray = ["YYYYMMddHHmm","YYYYMMddHHmm1","YYYYMMdd","YYYYMMdd1","HHmmHHmm","HHmmss"]
        for i in 0..<titleArray.count {
            let button = UIButton()
            button.setTitle(titleArray[i], for: .normal)
            button.tag = i + 200
            button.backgroundColor = UIColor.red
            button.addTarget(self, action: #selector(timePicker(send:)), for: .touchUpInside)
            button.frame = CGRect(x: Int((UIScreen.main.bounds.width - 200.0)/2), y: 150+(i*(50+10)), width: 200, height: 50)
            self.view.addSubview(button)
        }
        
        self.createPickerView(type: .YYYYMMddHHmm, tag: 300)
        self.createPickerView(type: .YYYYMMddHHmm1, tag: 301)
        self.createPickerView(type: .YYYYMMdd, tag: 302)
        self.createPickerView(type: .YYYYMMdd1, tag: 303)
        self.createPickerView(type: .HHmmHHmm, tag: 304)
        self.createPickerView(type: .HHmmss, tag: 305)
    }
    
    fileprivate func createPickerView(type:DateFormatType,tag:Int){
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY-MM-dd HH:mm:ss", options: 0, locale: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let begin  = dateFormatter.date(from: "2019-8-9 19:50:54")
        let end = dateFormatter.date(from: "2018-8-9 20:16:45")
        /**
         1. dateFormat 返回值格式以及选择器模式
         2.beginYear 开始年份
         3. beginDate 默认开始时间
         4. endDate默认结束时间
         */
       let datePicker = WLXDatePicker.init(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height), dateFormat: type, beginYear: 2000, beginDate: begin!, endDate: end!)
        datePicker.tag = tag
        
        datePicker.submitActionBlock = { [weak self] beginDate,endDate in
            if beginDate.count > 0 {
                print(beginDate)
               self?.resultLabel.text = beginDate
            }
            if beginDate.count > 0 && endDate.count > 0  {
                self?.resultLabel.text = beginDate + "-" + endDate
            }
            UIView.animate(withDuration: 0.4, animations: {
                datePicker.frame.origin.y = (self?.view.frame.height)!
            })
        }
        self.view.addSubview(datePicker)
    }
    
    @objc func timePicker(send:UIButton){
        UIView.animate(withDuration: 0.4) {
            let view = self.view.viewWithTag(send.tag - 200 + 300)
            view!.frame.origin.y = 0
        }
    }
    
}

