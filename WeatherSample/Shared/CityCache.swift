//
//  CityCache.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation

class CityCache {
    private let cityKey = "lastSearchedCity"
    
    func save(city: String) {
        UserDefaults.standard.set(city, forKey: cityKey)
    }
    
    func getLastCity() -> String? {
        return UserDefaults.standard.string(forKey: cityKey)
    }
}
