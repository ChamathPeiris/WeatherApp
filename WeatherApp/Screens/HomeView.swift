//
//  HomeView.swift
//  OpenWeatherMapApp
//
//  Created by Chamath Peiris on 2022-05-18.
//

import SwiftUI
import CoreLocationUI

struct HomeView: View {
    
    @State private var cityText = ""
    @StateObject var weatherManager = WeatherManager()
    @StateObject var locationManager: LocationManager = LocationManager.shared

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack() {
                        VStack(alignment: .leading) {
                            Text(weatherManager.weather?.name ?? "--")
                                .bold()
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                                .fontWeight(.light)
                                .foregroundColor(.white)
                            
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SearchView()) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .padding()
                                .background(.white)
                                .cornerRadius(100)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        VStack() {
                            Image(systemName: weatherManager.weather?.conditionIcon ?? "cloud")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            
                            Text("\(weatherManager.weather?.description ?? "--")")
                                .foregroundColor(.white)
                            
                        }
                        .frame(alignment: .leading)
                        
                        Spacer()
                        
                        Text("\(weatherManager.weather?.tempString ?? "--")°C")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                    }
                    .padding(.top)
                    Image("1")
                        .resizable()
                }
                .padding()
                
                Spacer()
                
                HStack {
                    
                    NavigationLink(destination: ForecastView()) {
                        Label("Forecast", systemImage: "")
                            .labelStyle(.titleOnly)
                            .padding()
                            .frame(width:160, height: 50)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(50.0)
                            .font(.system(size: 18, weight: Font.Weight.bold))
                        
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: IntervalWeatherView()) {
                        Label("Intervals", systemImage: "")
                            .labelStyle(.titleOnly)
                            .padding()
                            .frame(width:160, height: 50)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(50.0)
                            .font(.system(size: 18, weight: Font.Weight.bold))
                    }
                    
                }
                .padding()
                .frame(height: 150)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            .onAppear {
                Task {
                    locationManager.requestLocation()
                }
            }
            .onChange(of: locationManager.isLoading) { _ in
                Task {
                    await fetchCurrrentWeather(lat: locationManager.location?.latitude ?? 0, lon: locationManager.location?.longitude ?? 0)
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .background(
                LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .top, endPoint: .bottom)
            )
        }.accentColor(.white)
        
    }
    
    func fetchCurrrentWeather(lat: Double, lon: Double) async {
        await weatherManager.fetchForCurrentLocation(lat: lat, lon: lon)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
