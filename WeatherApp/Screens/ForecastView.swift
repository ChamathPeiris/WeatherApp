//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Chamath Peiris on 2022-05-18.
//

import SwiftUI



struct ForecastView: View {
    
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = WeatherManager()
    
    @StateObject var locationManager: LocationManager = LocationManager.shared
    
    var body: some View {
        VStack{
            
            
            //picking between metric or imperial
                Picker("", selection: $unit) {
                    Text("Metric")
                        .tag(WeatherUnit.metric)
                    Text("Imperial")
                        .tag(WeatherUnit.imperial)
                }
                .pickerStyle(.segmented)
                .padding()
            Spacer()
            //show forecast list to the current location
                if let data = manager.OCweather?.forecast {
                    List (0..<6) { index in
                        let item = data[index]
                        Section(header: HStack{
                            Text("\(item.dt)")
                                .foregroundColor(.white)
                        })
                        {
                            HStack(spacing: 20) {
                                Image(systemName: item.icon)
                                    .font(.title2)
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .background(.yellow)
                                    .cornerRadius(50)
                                
                                //show weather informations
                                VStack (alignment: .leading) {
                                    Text(item.weather.description.capitalized).foregroundColor(.white).fontWeight(.medium)
                                    Text("\(item.temp)").foregroundColor(.white).fontWeight(.medium)
                                    HStack {
                                        Image(systemName: "cloud.fill")
                                            .foregroundColor(.orange)
                                        Text("\(item.clouds)%").foregroundColor(.white).fontWeight(.medium)
                                        Image(systemName: "drop.fill")
                                            .foregroundColor(.orange)
                                        Text("\(item.wind_speed)").foregroundColor(.white).fontWeight(.medium)
                                        
                                    }
                                    Text("Humidity: \(item.humidity)%").foregroundColor(.white).fontWeight(.medium)
                                    
                                }
                            }.clipShape(RoundedRectangle(cornerRadius: 15))
                            .listRowBackground(Color.clear)
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onChange(of: unit) { _ in //change values between metric and imperial
                        Task {
                            await manager.getFiveDayForecast(lat: locationManager.location?.latitude ?? 0, lon: locationManager.location?.longitude ?? 0, unit: self.unit)
                        }
                    }
                }
            }
            .navigationTitle("Forecast")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .top, endPoint: .bottom)
            )
            
            .onAppear {
                Task {
                    //get weather forecast information
                    await manager.getFiveDayForecast(lat: locationManager.location?.latitude ?? 0, lon: locationManager.location?.longitude ?? 0, unit: self.unit)
                }
            }
    }
    
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
