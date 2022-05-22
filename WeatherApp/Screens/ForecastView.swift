//
//  RecentsView.swift
//  OpenWeatherMapApp
//
//  Created by Chamath Peiris on 2022-05-18.
//

import SwiftUI



struct ForecastView: View {
    
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OneCallWeatherManager()
    
    var body: some View {
        VStack{
                Picker("", selection: $unit) {
                    Text("Metric")
                        .tag(WeatherUnit.metric)
                    Text("Imperial")
                        .tag(WeatherUnit.imperial)
                }
                .pickerStyle(.segmented)
                .padding()
            Spacer()
                if let data = manager.weather?.forecast {
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
                    .onChange(of: unit) { _ in
                        Task {
                            await manager.getFiveDayForecast(unit: self.unit)
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
