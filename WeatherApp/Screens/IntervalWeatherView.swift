//
//  IntervalWeatherView.swift
//  OpenWeatherMapApp
//
//  Created by Chamath Peiris on 2022-05-18.
//

import SwiftUI

struct IntervalWeatherView: View {
    
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OneCallWeatherManager()
    
    var body: some View {
        VStack {
           
            if let data = manager.weather {
                if let current = data.current {
                    Text("\(current.dt)").foregroundColor(.white).fontWeight(.semibold)
                    HStack {
                        Image(systemName: current.icon)
                            .resizable()
                            .font(.title2)
                            .padding()
                            .background(.yellow)
                            .cornerRadius(50)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                        Text(current.temp)
                            .font(.system(size: 60, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    Text("Drizzly")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.white)
                    
                }
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
                await manager.getFiveDayForecast(unit: self.unit)
            }
        }
    }
}

struct IntervalWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        IntervalWeatherView()
    }
}
