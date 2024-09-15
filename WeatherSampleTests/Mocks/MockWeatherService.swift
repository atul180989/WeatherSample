//
//  MockWeatherService.swift
//  WeatherSampleTests
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation
@testable import WeatherSample

class MockWeatherService: WeatherService {
    
    var testResult: Result<WeatherModel, Error>?

    override func fetchWeather(for city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        if let result = testResult {
            completion(result)
        }
    }
    
    override func fetchWeather(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        if let result = testResult {
            completion(result)
        }
    }
}
