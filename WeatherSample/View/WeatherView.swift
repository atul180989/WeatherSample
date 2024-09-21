//
//  WeatherView.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/14/24.
//

import SwiftUI

struct WeatherView: View {
    
    // MARK: - Properties
    
    @State private var searchText = ""
    @State private var errorMessage: String? = nil
    @StateObject var viewModel: WeatherViewModel
    var coordinator: WeatherCoordinator
    
    var body: some View {
        VStack {
            // Search bar for city name
            TextField("Enter US city", text: $searchText, onCommit: {
                searchWeather()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .accessibilityLabel("Search field for city")
            .accessibilityHint("Enter a US city to get the weather data")
            
            // Display error message if any
            if let errorMessage = viewModel.error, !errorMessage.localizedDescription.isEmpty {
                Text(errorMessage.localizedDescription)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
                    .accessibilityLabel("Error message")
                    .accessibilityValue(errorMessage.localizedDescription)
            }
            // Weather info
            if let city = viewModel.cityName,
               let temperature = viewModel.temperature,
               let weatherDescription = viewModel.weatherDescription,
               let weatherIcon = viewModel.weatherIcon {
                Text(city)
                    .font(.largeTitle)
                    .padding(.top, 20)
                    .accessibilityLabel("City name")
                    .accessibilityValue(city)
                
                Text(temperature)
                    .font(.system(size: 64))
                    .fontWeight(.bold)
                    .accessibilityLabel("Temperature")
                    .accessibilityValue(temperature)
                
                Text(weatherDescription)
                    .font(.title2)
                    .padding(.bottom, 20)
                    .accessibilityLabel("Weather description")
                    .accessibilityValue(weatherDescription)
                
                if let icon = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {
                    AsyncImage(url: icon) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                    .accessibilityLabel("Weather icon")
                }
            }
            Spacer()
        }
        .onAppear {
            coordinator.onAppear()
        }
        .padding()
    }
    
    // MARK: - Methods
      
    private func searchWeather() {
        searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchText.isEmpty else {
            viewModel.error = NSError(domain: "", code: 400,
                                      userInfo: [NSLocalizedDescriptionKey: "Please enter a city name."])
            viewModel.cityName = nil
            return
        }
        viewModel.fetchWeather(for: searchText)
    }
}
