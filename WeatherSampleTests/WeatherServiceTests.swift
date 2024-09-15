//
//  WeatherServiceTests.swift
//  WeatherSampleTests
//
//  Created by Atul Bhaisare on 9/14/24.
//

import XCTest
@testable import WeatherSample

final class WeatherServiceTests: XCTestCase {

    private var weatherService: WeatherService!
    private var mockNetworkService: MockNetworkService!

    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        weatherService = WeatherService(networkService: mockNetworkService)
    }

    override func tearDownWithError() throws {
        weatherService = nil
        mockNetworkService = nil
    }

    // Test successful fetch by city name
    func testFetchWeatherByCitySuccess() {
        // Given: Prepare mock response for successful fetch
        let mockWeatherResponse = WeatherModel(
            main: WeatherModel.Main(temp: 72.0),
            weather: [WeatherModel.Weather(description: "Clear sky", icon: "01d")], name: "New Jersey"
        )
        
        mockNetworkService.testResult = .success(mockWeatherResponse)
        
        let expectation = self.expectation(description: "Weather fetched successfully")
        
        // When: Fetch weather by city name
        weatherService.fetchWeather(for: "New Jersey") { result in
            // Then: Verify successful result
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.main.temp, 72.0)
                XCTAssertEqual(weather.weather.first?.description, "Clear sky")
                XCTAssertEqual(weather.name, "New Jersey")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Test failure due to network error
    func testFetchWeatherByCityFailure() {
        // Given: Simulate network error
        let networkError = NSError(domain: "NetworkError", code: 1, userInfo: nil)
        mockNetworkService.testResult = .failure(networkError)
        
        let expectation = self.expectation(description: "Network request failed")
        
        // When: Fetch weather by city name
        weatherService.fetchWeather(for: "New York") { result in
            // Then: Verify failure result
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "NetworkError")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    // Test successful fetch by latitude and longitude
    func testFetchWeatherByCoordinatesSuccess() {
        // Given: Prepare mock response for successful fetch
        let mockWeatherResponse = WeatherModel(
            main: WeatherModel.Main(temp: 65.0),
            weather: [WeatherModel.Weather(description: "Partly cloudy", icon: "02d")], name: "New Jersey"
        )
        
        mockNetworkService.testResult = .success(mockWeatherResponse)
        
        let expectation = self.expectation(description: "Weather fetched successfully")
        
        // When: Fetch weather by coordinates
        weatherService.fetchWeather(forLatitude: 37.7749, longitude: -122.4194) { result in
            // Then: Verify successful result
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.main.temp, 65.0)
                XCTAssertEqual(weather.weather.first?.description, "Partly cloudy")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
