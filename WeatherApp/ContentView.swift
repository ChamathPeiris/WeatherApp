//
//  ContentView.swift
//  WeatherApp
//
//  Created by Malshan Perera on 2022-05-20.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var manager: LocationManager = LocationManager.shared
    
    var body: some View {
        HomeView().onAppear() {
            manager.requestPermission()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
