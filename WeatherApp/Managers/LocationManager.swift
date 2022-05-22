//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Chamath Peiris on 2022-05-20.
//

import Foundation
import CoreLocation

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-read-the-users-location-using-locationbutton
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    //creating an instance of CLLocationManager, the framework we use to get the coordinates
    static let shared = LocationManager()
    let manager = CLLocationManager()

    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        
        //assigning a delegate to our CLLocationManager instance
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        isLoading = true
        manager.requestAlwaysAuthorization()
    }
    
    //requests the one-time delivery of the user’s current location, see https://developer.apple.com/documentation/corelocation/cllocationmanager/1620548-requestlocation
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    //set the location coordinates to the location variable
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    
    //this function will be called if we run into an error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        isLoading = false
    }
    
    // check acessibility
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

            if manager.authorizationStatus == .authorizedWhenInUse{
                print("Authorized")
                manager.startUpdatingLocation()
            } else {
                print("not authorized")
                manager.requestWhenInUseAuthorization()
            }
        }
}
