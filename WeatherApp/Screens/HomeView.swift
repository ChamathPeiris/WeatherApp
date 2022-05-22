//
//  HomeView.swift
//  WeatherApp
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
                    //show the current location weather information
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
                        
                        //navigate to search view after tapping the search icon
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
                    
                    //show weather icons and temperature of current location
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
                    //display image of the home view
                    .padding(.top)
                    Image("1")
                        .resizable()
                }
                .padding()
                
                Spacer()
                
                HStack {
                    //navigate to forecast view after clicking the button
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
                    //navigate to intervals view after clicking the intervals button
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
                    
                }//button styles
                .padding()
                .frame(height: 150)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            .onAppear {
                Task {
                    //request for load the weather data
                    locationManager.requestLocation()
                }
            }
            .onChange(of: locationManager.isLoading) { _ in
                Task {
                    //request current location for load weather data
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
    
    //function for load current location
    func fetchCurrrentWeather(lat: Double, lon: Double) async {
        await weatherManager.fetchForCurrentLocation(lat: lat, lon: lon)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
