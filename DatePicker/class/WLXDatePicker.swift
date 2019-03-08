 //
//  WLXDatePicker.swift
//  ScanDemo
//
//  Created by WLX on 2018/12/5.
//  Copyright © 2018 WLX. All rights reserved.
//
 
 // 显示样式以及返回时间字符串格式
 public enum DateFormatType:Int {
    case YYYYMMddHHmm = 1 // YYYYMMdd HH:mm:ss
    case YYYYMMdd  // YYYYMMdd
    case YYYYMMddHHmm1 // YYYY-MM-dd HH:mm:ss
    case YYYYMMdd1  // YYYY-MM-dd
    case HHmmHHmm // 开始时间 结束时间
    case HHmmss // 时分秒
 }

import UIKit

private let YearLimit = 99 // 从当前年份往后多少年
 
class WLXDatePicker: UIView {
    
    fileprivate let pickerView = UIPickerView()
    fileprivate var dayCount = 31
    fileprivate var yearValue = 2018
    fileprivate var monthValue = 1
    fileprivate var dayValue = 1
    fileprivate var hourValue = 0
    fileprivate var minValue = 0
    fileprivate var secValue = 0
    fileprivate var endHour = 0
    fileprivate var endMin = 0
    fileprivate let bgView = UIView()
    fileprivate var dateFormat = DateFormatType.YYYYMMddHHmm1
    fileprivate var beginDate:Date = Date()
    fileprivate var endDate:Date = Date()
    fileprivate var beginYear:Int! // 如果传入0,默认从当年开始
    fileprivate var nowYear:Int! // 当前年份
    
    var submitActionBlock:((String,String)->())?
    
    init(frame:CGRect,dateFormat:DateFormatType,beginYear:Int,beginDate:Date,endDate:Date) {
        super.init(frame: frame)
        self.dateFormat = dateFormat
        self.beginDate = beginDate
        self.endDate = endDate
        self.beginYear = beginYear
        createUI()
    }

    fileprivate func createUI(){
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        self.addGestureRecognizer(tap)
        
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        bgView.frame = CGRect(x: 0, y: self.frame.height - 310, width: self.frame.width, height: 310)
        self.addSubview(bgView)
        
        bgView.backgroundColor = UIColor.init(red: 248, green: 248, blue: 248, alpha: 1)
        self.createButton(frame: CGRect(x: 12 , y: 10, width: 60, height: 40), title: "取消", titleColor: UIColor.lightGray, selector: #selector(cancleAction))
        
        self.createButton(frame: CGRect(x: bgView.frame.width - 12 - 60 , y: 10, width: 60, height: 40), title: "确认", titleColor: UIColor.blue, selector: #selector(submitAction))
        
        pickerView.backgroundColor = UIColor.init(red: 248, green: 248, blue: 248, alpha: 1)
        pickerView.frame = CGRect(x: 0, y:bgView.frame.size.height - 270 , width: self.frame.width, height: 270)
        pickerView.dataSource = self
        pickerView.delegate = self
        bgView.addSubview(pickerView)
        
        let calendar = Calendar.current
        let unit:NSCalendar.Unit = [
            NSCalendar.Unit.second,
            NSCalendar.Unit.minute,
            NSCalendar.Unit.hour,
            NSCalendar.Unit.day,
            NSCalendar.Unit.month,
            NSCalendar.Unit.year
        ]
        var defaultComponents:DateComponents = (calendar as NSCalendar).components(unit, from: Date())
        nowYear = defaultComponents.year
        if beginYear == 0 {
            beginYear = defaultComponents.year
        }
        defaultComponents = (calendar as NSCalendar).components(unit, from: beginDate)
        yearValue = defaultComponents.year!
        monthValue = defaultComponents.month!
        dayValue = defaultComponents.day!
        hourValue = defaultComponents.hour!
        minValue = defaultComponents.minute!
        secValue = defaultComponents.second!
        defaultComponents = (calendar as NSCalendar).components(unit, from: endDate)
    
        endHour = defaultComponents.hour!
        endMin = defaultComponents.minute!
        
        if dateFormat == .YYYYMMddHHmm1 || dateFormat == .YYYYMMddHHmm {
            pickerView.selectRow(yearValue - beginYear , inComponent: 0, animated: false)
            pickerView.selectRow(monthValue - 1, inComponent: 1, animated: false)
            pickerView.selectRow(dayValue - 1, inComponent: 2, animated: false)
            pickerView.selectRow(hourValue, inComponent: 3, animated: false)
            pickerView.selectRow(minValue, inComponent: 4, animated: false)
        }else if dateFormat == .YYYYMMdd || dateFormat == .YYYYMMdd1 {
            pickerView.selectRow(yearValue - beginYear, inComponent: 0, animated: false)
            pickerView.selectRow(monthValue - 1, inComponent: 1, animated: false)
            pickerView.selectRow(dayValue - 1, inComponent: 2, animated: false)
        }else if dateFormat == .HHmmss {
            pickerView.selectRow(hourValue, inComponent: 0, animated: false)
            pickerView.selectRow(minValue, inComponent: 1, animated: false)
            pickerView.selectRow(secValue, inComponent: 2, animated: false)
        }else if dateFormat == .HHmmHHmm {
            pickerView.selectRow(hourValue, inComponent: 0, animated: false)
            pickerView.selectRow(minValue, inComponent: 1, animated: false)
            pickerView.selectRow(endHour, inComponent: 3, animated: false)
            pickerView.selectRow(endMin, inComponent: 4, animated: false)
        }
        
    }
    
    @objc func cancleAction(){
        if self.submitActionBlock != nil {
            self.submitActionBlock!("","")
        }
    }
    @objc func submitAction(){
        if self.submitActionBlock != nil {
            let resultString = self.formatDate()
            self.submitActionBlock!(resultString.beginString,resultString.endString)
        }
    }
    // 格式化选中数据
    fileprivate func formatDate()->(beginString:String,endString:String){
        let month = String.init(format:"%02ld", monthValue)
        let day = String.init(format:"%02ld", dayValue)
        let hour = String.init(format:"%02ld", hourValue)
        let min = String.init(format:"%02ld", minValue)
        let sec = String.init(format:"%02ld", secValue)
        let eHour = String.init(format:"%02ld", endHour)
        let eMin = String.init(format:"%02ld", endMin)
        
        
        if self.dateFormat == .YYYYMMddHHmm {
            let resultString = "\(yearValue)"+"/"+"\(month)"+"/"+"\(day)"+" "+"\(hour)"+":"+"\(min)"+":00"
            return (resultString,"")
            
        }else if dateFormat == .YYYYMMddHHmm1 {
            let resultString = "\(yearValue)"+"-"+"\(month)"+"-"+"\(day)"+" "+"\(hour)"+":"+"\(min)"+":00"
            return (resultString,"")
        } else if self.dateFormat == .YYYYMMdd  {
            let resultString = "\(yearValue)"+"-"+"\(month)"+"-"+"\(day)"
            return (resultString,"")
            
        } else if self.dateFormat == .YYYYMMdd1 {
            let resultString = "\(yearValue)"+"/"+"\(month)"+"/"+"\(day)"
            return (resultString,"")
        }
         else if self.dateFormat == .HHmmHHmm {
            let beginString = "\(hour)"+":"+"\(min)"
            let endString = "\(eHour)"+":"+"\(eMin)"
            return (beginString,endString)
        }else if self.dateFormat == .HHmmss {
            let dateString = "\(hour)"+":"+"\(min)"+":"+"\(sec)"
            return (dateString,"")
        }
        return ("","")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createButton(frame:CGRect,title:String,titleColor:UIColor,selector:Selector){
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.init(red: 248, green: 248, blue: 248, alpha: 1)
        button.frame = frame
        button.setTitleColor(titleColor, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        bgView.addSubview(button)
    }
    @objc func tapAction(tap:UITapGestureRecognizer){
        let point:CGPoint = tap.location(in: bgView)
        if point.x < 0 || point.y < 0 {
           cancleAction()
        }
    }
}
 extension WLXDatePicker:UIPickerViewDelegate,UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if dateFormat == .YYYYMMddHHmm || dateFormat == .YYYYMMddHHmm1 {
        if component == 0 { // 年
            return YearLimit + (beginYear - nowYear)
        }else if component == 1 { // 月
            return 12
        }else if component == 2 { // 日
            if dayValue > dayCount {
                dayValue = dayCount
            }
            return dayCount
        }else if component == 3 { // 时
            return 24
        }else if component == 4 { // 分
            return 60
        }
        }else if dateFormat == .YYYYMMdd || dateFormat == .YYYYMMdd1 {
            if component == 0 { // 年
                return 99
            }else if component == 1 { // 月
                return 12
            }else if component == 2 { // 日
                if dayValue > dayCount {
                    dayValue = dayCount
                }
                return dayCount
            }
        }else if dateFormat == .HHmmHHmm {
            if component == 0 || component == 3{ // 时
                return 24
            } else if component == 1  || component == 4{ // 分
                return 60
            }else{
                return 1  // 分隔符
            }
        }else if dateFormat == .HHmmss {
            if component == 0 {
                return 24
            }else if component == 1 || component == 2{
                return 60
            }
        }
        return 6
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if dateFormat == .YYYYMMddHHmm || dateFormat == .YYYYMMddHHmm1 || dateFormat == .HHmmHHmm{
            return 5
        }else if dateFormat == .YYYYMMdd || dateFormat == .YYYYMMdd1 || dateFormat == .HHmmss {
            return 3
        }
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if dateFormat == .YYYYMMddHHmm1 || dateFormat == .YYYYMMddHHmm {
        if component == 0 {
            return "\(beginYear + row)"
        }else if component == 3 || component == 4 {
            if row < 10 {
                return "0\(row)"
            }
            return "\(row)"
        }
        if row + 1 < 10 {
            return "0\(row + 1)"
        }
        return "\(row + 1)"
        }else if dateFormat == .YYYYMMdd || dateFormat == .YYYYMMdd1 {
            if component == 0 {
                return "\(beginYear + row)"
            }
            if row + 1 < 10 {
                return "0\(row + 1)"
            }
            return "\(row + 1)"
        }else if dateFormat == .HHmmHHmm {
            if component == 2 {
                return "--"
            }
            if row < 10 {
                return "0\(row)"
            }
            return "\(row)"
        }else if dateFormat == .HHmmss {
            if component == 0 {
                if row + 1 < 10 {
                    return "0\(row + 1)"
                }
                return "\(row + 1)"
            }
            if row < 10 {
                return "0\(row)"
            }
            return "\(row)"
        }
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dateFormat == .YYYYMMddHHmm || dateFormat == .YYYYMMddHHmm1 {
        if component == 0 {
            yearValue = row + beginYear
            if self.monthValue == 2 {
                self.dayCalculation(month: monthValue, year: yearValue)
                pickerView.reloadComponent(2)
            }
        }else if component == 1 {
            monthValue = row + 1
            self.dayCalculation(month:monthValue , year: yearValue)
            pickerView.reloadComponent(2)
        }else if component == 2 {
            dayValue = row + 1
        }else if component == 3 {
            hourValue = row
        }else if component == 4 {
            minValue = row
        }
        }else if dateFormat == .YYYYMMdd || dateFormat == .YYYYMMdd1 {
            if component == 0 {
                yearValue = row + beginYear
                if self.monthValue == 2 {
                    self.dayCalculation(month: monthValue, year: yearValue)
                    pickerView.reloadComponent(2)
                }
            }else if component == 1 {
                monthValue = row + 1
                self.dayCalculation(month:monthValue , year: yearValue)
                pickerView.reloadComponent(2)
            }else if component == 2 {
                dayValue = row + 1
            }
        }else if dateFormat == .HHmmHHmm {
            if component == 0 {
                hourValue = row
            }else if component == 1 {
                minValue = row
            }else if component == 3 {
                endHour = row
            }else if component == 4 {
                endMin = row
            }
        }else if dateFormat == .HHmmss {
            if component == 0 {
                hourValue = row
            }else if component == 1 {
                minValue = row
            }else if component == 3 {
                secValue = row
            }
        }
    }
    
    //MARK: 计算每月天数
    fileprivate func dayCalculation(month:Int ,year:Int){
        
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12){
            dayCount = 31
        }else if month == 2 {
            // 判断闰年规则  ①、普通年能被4整除而不能被100整除的为闰年。（如2004年就是闰年,1900年不是闰年）
           //  ②、世纪年能被400整除而不能被3200整除的为闰年。(如2000年是闰年，3200年不是闰年)
            
            if yearValue%100 == 0 {
                if (yearValue%400 == 0 ) && (yearValue%3200 != 0){
                    dayCount = 29
                }else{
                    dayCount = 28
                }
            }else{
                if (yearValue%4 == 0) && (yearValue%100 != 0){
                    dayCount = 29
                }else{
                    dayCount = 28
                }
            }
        }else {
            dayCount = 30
        }
    }
 }
