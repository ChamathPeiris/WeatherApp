//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by Chamath Peiris on 2022-05-19.
//

import Foundation

//https://stackoverflow.com/questions/28404154/swift-get-local-date-and-time
extension Date {
    func get(_ type: Calendar.Component)-> Int {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return Int(t < 10 ? "0\(t)" : t.description) ?? 0
    }
}
