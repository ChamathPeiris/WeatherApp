//
//  IntervalWeatherView.swift
//  WeatherApp
//
//  Created by Chamath Peiris on 2022-05-18.
//

import SwiftUI

struct IntervalWeatherView: View {
    
    @State private var unit: WeatherUnit = .metric
    @StateObject var weatherManager = WeatherManager()
    @StateObject var locationManager: LocationManager = LocationManager.shared
    
    var body: some View {
        VStack {
           
            
            if let data = weatherManager.OCweather {
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: weatherManager.weather?.conditionIcon ?? "cloud")
                            .resizable()
                            .font(.title2)
                            .padding()
                            .background(.yellow)
                            .cornerRadius(50)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                        Text("\(weatherManager.weather?.tempString ?? "--")°C")
                            .font(.system(size: 60, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                    }
                
                Text("\(weatherManager.weather?.description ?? "--")")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.white)
                    
                
                //load weather information according to 3 hours by 3 hours
                List (data.hourlyForecasts) { item in
                  
                    HStack(spacing: 20) {
                        Image(systemName: item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                            .background(.tertiary)
                            .cornerRadius(50)
                        VStack (alignment: .leading) {
                            Text(item.weather.description.capitalized)
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium, design: .rounded))

                            Text(item.dt)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            
                        }
                        Spacer()
                        Text("\(item.temp)")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }.listRowBackground(Color.clear)
                    
                }
                .listStyle(PlainListStyle())
            } else {
                Spacer()
            }
        }
        .navigationTitle("Intervals")
        .accentColor(.white)
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .top, endPoint: .bottom)
        )
        
        .onAppear {
            Task {
                //request current location
                locationManager.requestLocation()
            }
        }.onChange(of: locationManager.isLoading) { _ in
            Task {
                //request forecast weather data and fetch current location for load weather data
                await weatherManager.getFiveDayForecast(lat: locationManager.location?.latitude ?? 0, lon: locationManager.location?.longitude ?? 0, unit: self.unit)
                await fetchCurrrentWeather(lat: locationManager.location?.latitude ?? 0, lon: locationManager.location?.longitude ?? 0)
                
            }
        }
        
    }
    //function for load current location
    func fetchCurrrentWeather(lat: Double, lon: Double) async {
        await weatherManager.fetchForCurrentLocation(lat: lat, lon: lon)
    }
    
}

struct IntervalWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        IntervalWeatherView()
    }
}
