//
//  ViewController.swift
//  DatePicker
//
//  Created by WLX on 2018/12/6.
//  Copyright © 2018 WLX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var datePickerView:WLXDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    fileprivate func createUI(){
        
        let button = UIButton()
        button.setTitle("测试", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(timePicker), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        self.view.addSubview(button)
        
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY-MM-dd HH:mm:ss", options: 0, locale: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let begin  = dateFormatter.date(from: "2019-8-9 19:50:54")
        let end = dateFormatter.date(from: "2018-8-9 20:16:45")
        
        datePickerView = WLXDatePicker.init(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height), dateFormat: .YYYYMMddHHmm, beginYear: 2000, beginDate: begin!, endDate: end!)
        
        datePickerView.submitActionBlock = { [weak self] beginDate,endDate in
            if beginDate.count > 0 {
                print(beginDate)
            }
            if endDate.count > 0  {
                print(endDate)
            }
            UIView.animate(withDuration: 0.4, animations: {
                self?.datePickerView.frame.origin.y = (self?.view.frame.height)!
            })
        }
        let window:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        window.window?.addSubview(datePickerView)
    }
    
    @objc func timePicker(){
        UIView.animate(withDuration: 0.4) {
            self.datePickerView.frame.origin.y = 0
        }
    }
    
}

