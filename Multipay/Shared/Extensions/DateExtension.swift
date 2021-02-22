//
//  DateExtension.swift
//  PayByUp
//
//  Created by Göktuğ Aral on 01/06/17.
//  Copyright © 2017 Göktuğ Aral. All rights reserved.
//

import Foundation

//Special need for PayByUP bussiness architecht
//We have to format as GMT difference

//MultiPay için düzenlenecek.

class DateManager {
    
    
    func timeAgoSince(date:NSDate, numericDates:Bool) -> String
    {
        let calendar = NSCalendar.current
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let unitFlags = Set<Calendar.Component>([.minute, .hour, .day, .weekOfYear, .month, .year, .second])
        let components = calendar.dateComponents(unitFlags, from: earliest as Date, to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2)
        {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2)
        {
            return "\(components.minute!) " + "MUNITES_AGO".local
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 " + "MUNITE_AGO".local
            } else {
                return "A " + "MUNITE_AGO".local
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) " + "SECONDS_AGO".local
        } else {
            return "JUST_NOW".local
        }
        
    }
    
}

//MARK: String Extensions of Date
extension String {
    
    func getLastUpdatedDateToDislay() -> String {
        
        let identifier = CoreManager.getLocaleIdentifier()//CoreManager.instance.loadLanguage()?.languageCode
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "E dd MMMM"

        let showDate = dateFormatter.string(from: date)  // "Wed 27 July"
        return showDate
    }
    
    func getLastUpdatedTimeToDislay() -> String {
        
        let identifier = CoreManager.getLocaleIdentifier()//CoreManager.instance.loadLanguage()?.languageCode
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm"
        
        let showTime = dateFormatter.string(from: date)
        return showTime
    }
    
    func formatDateAndTimeToDisplay() -> String {
        let identifier = CoreManager.getLocaleIdentifier()//CoreManager.instance.loadLanguage()?.languageCode
        
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        //dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        let localTimeString = dateFormatter.string(from: date!)
        
        return localTimeString
    }
    
    func formatOnlyDateToDisplay() -> String {
        let identifier = CoreManager.getLocaleIdentifier()//CoreManager.instance.loadLanguage()?.languageCode
        
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.dateFormat = "E dd MMMM"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .short
        
        let localTimeString = dateFormatter.string(from: date!)
        
        return localTimeString
    }
    
    func formatOnlyTimeToDisplay() -> String {
        let identifier = CoreManager.getLocaleIdentifier()//CoreManager.instance.loadLanguage()?.languageCode
        
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeStyle = .short
        
        let localTimeString = dateFormatter.string(from: date!)
        
        return localTimeString
    }
    
    func formatTermsDateToDisplay() -> String {
        let identifier = CoreManager.getLocaleIdentifier()//CoreManager.instance.loadLanguage()?.languageCode
        
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let localTimeString = dateFormatter.string(from: date!)
        
        return localTimeString
    }
    
    
}
