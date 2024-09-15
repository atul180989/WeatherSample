//
//  MockURLProtocol.swift
//  WeatherSampleTests
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation

class MockURLProtocol: URLProtocol {

    static var testURLs = [URL?: Data]()
    static var response: URLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true // Handle all types of requests
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else if let url = request.url, let data = MockURLProtocol.testURLs[url] {
            if let response = MockURLProtocol.response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required by protocol but no operation needed here
    }
}
