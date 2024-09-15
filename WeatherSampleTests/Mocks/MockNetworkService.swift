//
//  MockNetworkService.swift
//  WeatherSampleTests
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation
@testable import WeatherSample

class MockNetworkService: NetworkService {
    
    var testResult: Result<WeatherModel, Error>?
    
    override func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void)  {
        if let result = testResult as? Result<T, Error> {
            completion(result)
        }
    }
}
