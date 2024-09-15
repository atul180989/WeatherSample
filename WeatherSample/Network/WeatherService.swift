//
//  WeatherService.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation

class WeatherService {
    
    // MARK: - Properties
    
    private let networkService: NetworkService
    
    // MARK: - Initialize
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    // Fetch weather by city name
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let urlString = "\(WeatherAPI.baseURL.rawValue)?q=\(city)&appid=\(WeatherAPI.apiKey.rawValue)&units=imperial"
        networkService.fetchData(urlString: urlString, completion: completion)
    }
    
    // Fetch weather by latitude and longitude
    func fetchWeather(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let urlString = "\(WeatherAPI.baseURL.rawValue)?lat=\(latitude)&lon=\(longitude)&appid=\(WeatherAPI.apiKey.rawValue)&units=imperial"
        networkService.fetchData(urlString: urlString, completion: completion)
    }
}
