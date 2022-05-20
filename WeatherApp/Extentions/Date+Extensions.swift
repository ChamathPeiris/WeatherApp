//
//  Date+Extensions.swift
//  OpenWeatherMapApp
//
//  Created by Visal Rajapakse on 2022-05-12.
//

import Foundation

extension Date {
    func get(_ type: Calendar.Component)-> Int {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return Int(t < 10 ? "0\(t)" : t.description) ?? 0
    }
}
