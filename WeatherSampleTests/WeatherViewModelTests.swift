//
//  WeatherViewModelTests.swift
//  WeatherSampleTests
//
//  Created by Atul Bhaisare on 9/14/24.
//

import XCTest
import Foundation
@testable import WeatherSample

final class WeatherViewModelTests: XCTestCase {
    
    private var viewModel: WeatherViewModel!
    private var mockWeatherService: MockWeatherService!
    
    override func setUpWithError() throws {
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockWeatherService = nil
    }

    // Test successful weather fetch by city
    func testFetchWeatherByCitySuccess() {
        // Given: Prepare mock response for successful fetch
        let mockWeatherResponse = WeatherModel(
            main: WeatherModel.Main(temp: 72.0),
            weather: [WeatherModel.Weather(description: "Clear sky", icon: "01d")], name:"New Jersey")
        
        mockWeatherService.testResult = .success(mockWeatherResponse)
        
        // When: Fetch weather by city
        viewModel.fetchWeather(for: "New Jersey")
        
        // Then: Verify the view model properties are updated correctly
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.cityName, "New Jersey")
            XCTAssertEqual(self.viewModel.temperature, "72.0°F")
            XCTAssertEqual(self.viewModel.weatherDescription, "Clear Sky")
            XCTAssertEqual(self.viewModel.weatherIcon, "01d")
        }
    }
    
    // Test failure case when fetching weather by city
    func testFetchWeatherByCityFailure() {
        // Given: Simulate a failure response
        let networkError = NSError(domain: "NetworkError", code: 1, userInfo: nil)
        mockWeatherService.testResult = .failure(networkError)
        
        // When: Fetch weather by city
        viewModel.fetchWeather(for: "San Francisco")
        
        // Then: Verify that the view model does not update the weather properties
        XCTAssertEqual(viewModel.cityName, "")
        XCTAssertEqual(viewModel.temperature, "")
        XCTAssertEqual(viewModel.weatherDescription, "")
        XCTAssertEqual(viewModel.weatherIcon, "")
    }
}
