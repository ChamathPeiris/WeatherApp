//
//  RecentsView.swift
//  OpenWeatherMapApp
//
//  Created by Visal Rajapakse on 2022-04-29.
//

import SwiftUI



struct ForecastView: View {
    
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OneCallWeatherManager()
    
    var body: some View {
            VStack {
                Picker("", selection: $unit) {
                    Text("Metric")
                        .tag(WeatherUnit.metric)
                    Text("Imperial")
                        .tag(WeatherUnit.imperial)
                }
                .pickerStyle(.segmented)
                .padding()
                if let data = manager.weather?.forecast {
                    List (0..<6) { index in
                        let item = data[index]
                        Section("\(item.dt)") {
                            HStack(spacing: 20) {
                                Image(systemName: item.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.cyan)
                                VStack (alignment: .leading) {
                                    Text(item.weather.description)
                                    Text("\(item.temp)")
                                    HStack {
                                        Image(systemName: "cloud.fill")
                                            .foregroundColor(.gray)
                                        Text("\(item.clouds)%")
                                        Image(systemName: "drop")
                                            .foregroundColor(.blue)
                                        Text("\(item.wind_speed)")
                                    }
                                    Text("Humidity: \(item.humidity)%")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onChange(of: unit) { _ in
                        Task {
                            await manager.getFiveDayForecast(unit: self.unit)
                        }
                    }
                }
            }
            .navigationTitle("Forecast")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await manager.getFiveDayForecast(unit: self.unit)
                }
            }
        
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
