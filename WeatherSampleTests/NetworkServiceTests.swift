//
//  NetworkServiceTests.swift
//  WeatherSampleTests
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation
import XCTest
@testable import WeatherSample

final class NetworkServiceTests: XCTestCase {
    
    private var networkService: NetworkService!
    private let mockURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=NewYork&appid=YOUR_API_KEY&units=imperial")!
    
    override func setUpWithError() throws {
        // Create custom URLSessionConfiguration with MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        // Create custom URLSession with the mock protocol
        let session = URLSession(configuration: config)
        
        // Initialize the NetworkService with the mock session
        networkService = NetworkService(session: session)
    }
    
    override func tearDownWithError() throws {
        networkService = nil
        MockURLProtocol.testURLs = [:]
        MockURLProtocol.response = nil
        MockURLProtocol.error = nil
    }
    
    // Test success case where valid data is returned
    func testFetchDataSuccess() {
        // Given: Prepare mock weather response
        let mockWeatherResponse = WeatherModel(
            main: WeatherModel.Main(temp: 72.0),
            weather: [WeatherModel.Weather(description: "Clear sky", icon: "01d")], name: "New York"
        )
        let mockData = try! JSONEncoder().encode(mockWeatherResponse)
        
        // When: Configure MockURLProtocol to return this mock data
        MockURLProtocol.testURLs = [mockURL: mockData]
        MockURLProtocol.response = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let expectation = self.expectation(description: "Data fetched successfully")
        
        // Then: Make the network call
        networkService.fetchData(urlString: mockURL.absoluteString) { (result: Result<WeatherModel, Error>) in
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.main.temp, 72.0)
                XCTAssertEqual(weather.weather.first?.description, "Clear sky")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Test failure case with network error
    func testFetchDataFailure() {
        // Given: Configure MockURLProtocol to return an error
        MockURLProtocol.error = NSError(domain: "TestError", code: 1, userInfo: nil)
        
        let expectation = self.expectation(description: "Network request failed")
        
        // Then: Make the network call
        networkService.fetchData(urlString: mockURL.absoluteString) { (result: Result<WeatherModel, Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure:
                expectation.fulfill() // Expecting an error, test should pass
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Test invalid URL handling
    func testFetchDataInvalidURL() {
        // Given: An invalid URL string
        let invalidURLString = ""
        
        let expectation = self.expectation(description: "Invalid URL handled")
        
        // When: Making a network call with an invalid URL
        networkService.fetchData(urlString: invalidURLString) { (result: Result<WeatherModel, Error>) in
            // Then: Verify that the correct error is returned
            switch result {
            case .success:
                XCTFail("Expected failure due to invalid URL, but got success")
            case .failure(let error):
                // Check if the error is the invalid URL error
                if case NetworkService.NetworkError.invalidURL = error {
                    expectation.fulfill() // Test passed
                } else {
                    XCTFail("Expected invalidURL error, got: \(error)")
                }
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
