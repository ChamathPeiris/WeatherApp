//
//  WeatherRow.swift
//  WeatherApp
//
//  Created by user215318 on 5/21/22.
//

import SwiftUI

struct WeatherRow: View {
    var logo: String
    var name: String
    var value: String
    var unit : String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: logo)
                .font(.title2)
                .frame(width: 25, height: 25)
                .padding()
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                .cornerRadius(50)

            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.caption)
                
                Text(value)
                    .bold()
                    .font(.title)+Text(unit)
                    .bold()
                    .font(.title)
            }
        }
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(logo: "thermometer", name: "Feels like", value: "8°", unit: "C")
    }
}
