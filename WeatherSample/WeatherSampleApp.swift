//
//  WeatherSampleApp.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/13/24.
//

import SwiftUI

@main
struct WeatherSampleApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = WeatherViewModel()
            let coordinator = WeatherCoordinator(viewModel: viewModel)
            WeatherView(viewModel: viewModel, coordinator: coordinator)
        }
    }
}
