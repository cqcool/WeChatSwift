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
    func chatSingleFormatTime(message: Message) {
        chatFormatTime(messageList: [message])
    }
    func chatFormatTime(messageList: [Message]) {
        let nowTimestamp = Date().timeIntervalSince1970 * 1000
        let oneDaySecond: TimeInterval = 24 * 60 * 60 * 1000
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear], from: date)
        let curYear = components.year
        let curDay = components.day
        var previousTime = ""
        for message in messageList {
            let groupTimestamp = message.time
            if groupTimestamp == 0 {
                continue
            }
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
                let timeStr = time + "\(String(format: "%02d", groupComponents.hour ?? 0)):\(String(format: "%02d", groupComponents.minute ?? 0))"
                if timeStr != previousTime {
                    message._formattedTime = timeStr
                    previousTime = timeStr
                } else {
                    message._formattedTime = nil
                }
                
                continue
            }
            
            // 不是同一年的
            if let groupYear = groupComponents.year,
               let year = curYear {
                var yearStr: String = ""
                if groupYear != year {
                    yearStr = "\(groupYear)年"
                }
                let timeStr = "\(yearStr)\(groupComponents.month ?? 1)月\(groupComponents.day ?? 1)日"
                if timeStr != previousTime {
                    message._formattedTime = timeStr
                    previousTime = timeStr
                } else {
                    message._formattedTime = nil
                }
                continue
            }
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
                
                if date.isInSameWeek(as: groupDate) {
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

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}
