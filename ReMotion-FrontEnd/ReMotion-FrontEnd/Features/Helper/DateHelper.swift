//
//  DateHelper.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 29/10/25.
//

import Foundation

final class DateHelper {
    
    static func convertDateToStr(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter.string(from: date)
    }
    
    static func formatDateForDisplay(dateString: String) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "id_ID")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
        
    }
    
}
