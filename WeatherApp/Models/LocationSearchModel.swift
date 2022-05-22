//
//  LocationSearchModel.swift
//  WeatherApp
//
//  Created by user215318 on 5/22/22.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var isFail: Bool = false
    
    func addToFavorites(pizza: Pizza) {
        pizza.favorite = isFavorite
        PersistenceController.shared.saveContext()
        
    }
}
