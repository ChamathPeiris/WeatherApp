//
//  SearchView.swift
//  OpenWeatherMapApp
//
//  Created by Chamath Peiris on 2022-05-18.
//

import SwiftUI

struct SearchView: View {
    
    @State private var cityText = ""
    @State private var unitToggle = false
    
    @StateObject var manager = WeatherManager()
    @State private var unit: WeatherUnit = .metric
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 30)!]
        
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter a city", text: $cityText)
                    .textFieldStyle(.roundedBorder)
                Button {
                    
                    Task {
                        
                        await manager.fetchForCity(string: self.cityText, unit: unitToggle ? .imperial : .metric)
                    }
                    
                    
                }

            label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .padding()
                    .background(.white)
                    .cornerRadius(100)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
            }
                
            }.errorAlert(error: $manager.error)
            
            Picker("", selection: $unit) {
                Text("Metric")
                    .tag(WeatherUnit.metric)
                Text("Imperial")
                    .tag(WeatherUnit.imperial)
            }
            .pickerStyle(.segmented)
            .padding()
            if let data = manager.weather?.detailedData {
                Text("Weather now")
                    .bold()
                    .padding()
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 20) {
                    List(data) { item in
                        
                        HStack {
                            WeatherRow(logo: item.icon, name: item.title, value:("\(item.value)") , unit: item.unit)
                            Spacer()
                        }.listRowBackground(Color.clear)                      }
                    
                }
                
                .listStyle(PlainListStyle())
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(.primary)
                .background(.cyan)
                .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
            } else {
                Spacer()
                Image("2")
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                Spacer()
            }
        }
        .onChange(of: unit) { _ in
            Task {
                await manager.fetchForCity(string: self.cityText, unit: self.unit)
            }
        }
        .padding()
        .navigationBarTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .top, endPoint: .bottom)
        )
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
