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
        ZStack{
            Image("bg")
                       .resizable()
                       //.scaledToFill()
                       .edgesIgnoringSafeArea(.all)
            
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
                                    .font(.title2)
                                    .frame(width: 28, height: 28)
                                    .padding()
                                    .background(.yellow)
                                    .cornerRadius(50)
                                Spacer()
                                VStack (alignment: .leading) {
                                    Text(item.weather.description.capitalized)
                                    Text("\(item.temp)")
                                    HStack {
                                        Image(systemName: "cloud.fill")
                                            .foregroundColor(.cyan)
                                        Text("\(item.clouds)%")
                                        Image(systemName: "drop")
                                            .foregroundColor(.blue)
                                        Text("\(item.wind_speed)")
                                    }
                                    Text("Humidity: \(item.humidity)%")
                                }
                            }.clipShape(RoundedRectangle(cornerRadius: 15))                        }
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
