# DatePicker
一、 使用的时候可以根据自己的功能需求去配置。

1、 配置时间返回格式和选择器模式
 ````
 // 显示样式以及返回时间字符串格式
 public enum DateFormatType:Int {
    case YYYYMMddHHmm = 1 // YYYYMMdd HH:mm:ss
    case YYYYMMdd  // YYYYMMdd
    case YYYYMMddHHmm1 // YYYY-MM-dd HH:mm:ss
    case YYYYMMdd1  // YYYY-MM-dd
    case HHmmHHmm // 开始时间 结束时间
    case HHmmss // 时分秒
 }
 
 ````
2、 配置年份向后多少年

````
private let YearLimit = 99 // 从当前年份往后多少年

````
 二、使用方式
 ````
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
        datePickerView = WLXDatePicker.init(
            frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width,height: self.view.frame.height), 
            dateFormat: .YYYYMMddHHmm, 
            beginYear: 2000,
            beginDate: begin!, 
            endDate: end!
            )
        
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
