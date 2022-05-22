//
//  ContentView.swift
//  WeatherApp
//
//  Created by Chamath Peiris on 2022-05-16.
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
