//
//  WeatherModel.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation

struct WeatherModel: Codable {
    
    // MARK: - Properties
    
    let main: Main
    let weather: [Weather]
    let name: String
    
    struct Main: Codable {
        
        // MARK: - Properties
        
        let temp: Double
    }
    
    struct Weather: Codable {
        
        // MARK: - Properties
        
        let description: String
        let icon: String
    }
}
