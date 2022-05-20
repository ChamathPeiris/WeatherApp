//
//  String+Extensions.swift
//  OpenWeatherMapApp
//
//  Created by Visal Rajapakse on 2022-04-29.
//

import Foundation

extension Int {
    /// Converts OpenWeatherAPI Unix date to Date
    /// - Returns: Optional Date conversion
    func unixToDate(date: Date.FormatStyle.DateStyle = .long, time: Date.FormatStyle.TimeStyle = .omitted) -> String? {
        return Date(timeIntervalSince1970: TimeInterval(self)).formatted(date: date, time: time)
    }
    
    func unixToDate(date: Date.FormatStyle.DateStyle = .long, time: Date.FormatStyle.TimeStyle = .omitted) -> Date? {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}


