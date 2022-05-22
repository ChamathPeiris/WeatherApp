//
//  Double+Extensions.swift
//  WeatherApp
//
//  Created by Chamath Peiris on 2022-05-19.
//

import Foundation

//round the decimal values
extension Double {
    func fixedTo(_ places: Int) -> Double {
        let divisor: Double = pow(10, Double(places))
        return (divisor * self).rounded() / divisor
    }
}
