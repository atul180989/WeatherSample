//
//  NetworkService.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation

class NetworkService {
    
    // MARK: - Properties
    
    private var session: URLSession
    
    // MARK: - Initialize
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Network Operation
    
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
