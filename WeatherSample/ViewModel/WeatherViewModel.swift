//
//  WeatherViewModel.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/14/24.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var cityName: String?
    @Published var temperature: String?
    @Published var weatherDescription: String?
    @Published var weatherIcon: String?
    @Published var error: Error? = nil
    
    private let weatherService: WeatherService
    private let cityCache = CityCache()
    private let locationManager = CLLocationManager()
    
    // MARK: - Initialize
    
    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
        super.init()
        locationManager.delegate = self
        loadLastSearchedCity()
    }
    
    // MARK: - Network Operation
    
    func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    self?.cityName = city
                    self?.temperature = "\(weatherResponse.main.temp)°F"
                    self?.weatherDescription = weatherResponse.weather.first?.description.capitalized ?? ""
                    self?.weatherIcon = weatherResponse.weather.first?.icon ?? ""
                    self?.cityCache.save(city: city)
                    self?.error = nil
                case .failure(let error):
                    self?.error = error
                    self?.cityName = nil
                    self?.temperature = nil
                    self?.weatherDescription = nil
                    self?.weatherIcon = nil
                }
            }
        }
    }
    
    func loadLastSearchedCity() {
        if let lastCity = cityCache.getLastCity() {
            fetchWeather(for: lastCity)
        }
    }
    
    private func fetchWeather(forLatitude latitude: Double, longitude: Double) {
        weatherService.fetchWeather(forLatitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case.success(let weatherResponse):
                DispatchQueue.main.async {
                    self?.cityName = weatherResponse.name
                    self?.temperature = "\(weatherResponse.main.temp)°F"
                    self?.weatherDescription = weatherResponse.weather.first?.description.capitalized ?? ""
                    self?.weatherIcon = weatherResponse.weather.first?.icon ?? ""
                }
            case.failure(let error):
                self?.error = error
                self?.cityName = nil
                self?.temperature = nil
                self?.weatherDescription = nil
                self?.weatherIcon = nil
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewModel: CLLocationManagerDelegate {
    
    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        fetchWeather(forLatitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
}
