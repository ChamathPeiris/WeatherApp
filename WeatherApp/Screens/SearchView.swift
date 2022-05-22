//
//  SearchView.swift
//  WeatherApp
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
        //style for navigation bar appearance
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 30)!]
        
    }
    
    var body: some View {
        VStack {
            //display search bar for search weather information in any location
            HStack {
                TextField("Enter a city", text: $cityText)
                    .textFieldStyle(.roundedBorder)
                    .accentColor(.black)
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
                
            }.errorAlert(error: $manager.error) //error alert for non exist locations
            
            Picker("", selection: $unit) {
                Text("Metric")
                    .tag(WeatherUnit.metric)
                Text("Imperial")
                    .tag(WeatherUnit.imperial)
            }
            .pickerStyle(.segmented)
            .padding()
            
            //get detailed data according to the searched location
            if let data = manager.weather?.detailedData {
                Text("Weather now")
                    .bold()
                    .padding()
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 20) {
                    List(data) { item in
                        
                        //show weather information
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
                //if there is no data display a picture
                Image("2")
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                Spacer()
            }
        }
        .onChange(of: unit) { _ in
            Task {
                //values cahanges between metric and imperial
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
