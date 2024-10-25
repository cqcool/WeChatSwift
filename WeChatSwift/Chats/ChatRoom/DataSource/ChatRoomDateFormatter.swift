//
//  ChatRoomDateFormatter.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/14.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

/*
 https://kf.qq.com/faq/161224e2i22a161224qqYfAR.html
 微信聊天消息时间显示说明
 1、当天的消息，以每5分钟为一个跨度的显示时间；
 2、消息超过1天、小于1周，显示星期+收发消息的时间；
 3、消息大于1周，显示手机收发时间的日期。
 
 https://36kr.com/p/5213185
 12时
 0点到6点时为“凌晨”
 6点到12点时为“上午”
 12点到24点时为“下午”
 
 */

class ChatRoomDateFormatter {
    
    func formatTimestamp(_ timestamp: TimeInterval) -> String? {
        let nowTimestamp = Date().timeIntervalSince1970 * 1000
        let day: TimeInterval = 24 * 60 * 60
        let intervals = nowTimestamp - timestamp
        if timestamp >= nowTimestamp {
            return "11:20"
        }
        if intervals >= 7 * day {
            return "2019年7月22号 下午7:00"
        } else if intervals > day {
            return "星期一 上午8:14"
        } else if intervals > 0 {
            return "下午2:14"
        } else {
            return "下午2:14"
        }
    }
    
    static func groupFormatTime(groupList: [GroupEntity]) {
        let nowTimestamp = Date().timeIntervalSince1970 * 1000
        let oneDaySecond: TimeInterval = 24 * 60 * 60 * 1000
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear], from: date)
        let curYear = components.year
        let curDay = components.day
        for group in groupList {
            if let groupTimestamp = group.newAckMsgDate {
                let groupDate = Date(timeIntervalSince1970: groupTimestamp/1000)
                let groupComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear], from: groupDate)
                    
                    /*
                     今天：小于24h且在同一天
                     昨天：小于24h且不在同一天
                     */
                if nowTimestamp - groupTimestamp < oneDaySecond {
                    var time: String = ""
                    if curDay != (groupComponents.day ?? 0) {
                        time = "昨天 "
                    }
                    group._formattedTime = time + "\(String(format: "%02d", groupComponents.hour ?? 0)):\(String(format: "%02d", groupComponents.minute ?? 0))"
                    continue
                }
                // 同一星期
                
                if date.isSameWeek(date: groupDate) {
                    group._formattedTime = "星期" + numberToChinese(number: groupComponents.weekday ?? 1)
                    return
                }
                // 不是同一年的
                if let groupYear = groupComponents.year,
                   let year = curYear {
                    var yearStr: String = ""
                    if groupYear != year {
                        yearStr = "\(groupYear)年"
                    }
                    group._formattedTime = "\(yearStr)\(groupComponents.month ?? 1)月\(groupComponents.day ?? 1)日"
                    continue
                }
            }
            group._formattedTime = nil
        }
    }
    
    static func numberToChinese(number: Int) -> String {
        let array = ["一", "二", "三", "四", "五", "六", "日"]
        return array[number - 1]
    }
}

// MARK: - 分类.  时间间隔判断
extension Date {
    // MARK: - private method
    // MARK: 两个日期的间隔
    private func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return abs(components.day!)
    }
    
    // MARK: 日期对应当周的周几. 周一为开始, 周天为结束
    private func dayForWeekAtIndex() -> Int {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        
        return (components.weekday! - 1) == 0 ? 7 : (components.weekday! - 1)
    }
    
    // MARK: - public method
    // MARK: 判断是否为同一周
    func isSameWeek(date: Date) -> Bool {
        let differ = self.daysBetweenDate(toDate: date)
        // 判断哪一个日期更早
        let compareResult = Calendar.current.compare(self, to: date, toGranularity: Calendar.Component.day)
        
        // 获取更早的日期
        var earlyDate: Date
        if compareResult == ComparisonResult.orderedAscending {
            earlyDate = self
        }else {
            earlyDate = date
        }
        print(earlyDate)
        
        let indexOfWeek = earlyDate.dayForWeekAtIndex()
        let result = differ + indexOfWeek
        
        return result > 7 ? false : true
    }
}
