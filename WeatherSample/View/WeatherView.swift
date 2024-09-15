//
//  WeatherView.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/14/24.
//

import SwiftUI

struct WeatherView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = WeatherViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            // Search bar for city name
            TextField("Enter US city", text: $searchText, onCommit: {
                viewModel.fetchWeather(for: searchText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .accessibilityLabel("Search field for city")
            .accessibilityHint("Enter a US city to get the weather data")
            
            // Weather info
            if !viewModel.cityName.isEmpty {
                Text(viewModel.cityName)
                    .font(.largeTitle)
                    .padding(.top, 20)
                    .accessibilityLabel("City name")
                    .accessibilityValue(viewModel.cityName)
                
                Text(viewModel.temperature)
                    .font(.system(size: 64))
                    .fontWeight(.bold)
                    .accessibilityLabel("Temperature")
                    .accessibilityValue(viewModel.temperature)
                
                Text(viewModel.weatherDescription)
                    .font(.title2)
                    .padding(.bottom, 20)
                    .accessibilityLabel("Weather description")
                    .accessibilityValue(viewModel.weatherDescription)
                
                if let icon = URL(string: "https://openweathermap.org/img/wn/\(viewModel.weatherIcon)@2x.png") {
                    AsyncImage(url: icon) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                    .accessibilityLabel("Weather icon")
                }
            } else {
                Text("Enter a city to see weather")
                    .accessibilityLabel("Prompt to enter a city")
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.requestLocationAccess()
            viewModel.loadLastSearchedCity()
        }
        .padding()
    }
}
