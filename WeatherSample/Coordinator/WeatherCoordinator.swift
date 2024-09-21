//
//  WeatherCoordinator.swift
//  WeatherSample
//
//  Created by Atul Bhaisare on 9/20/24.
//

import Foundation

class WeatherCoordinator {
    
    var viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }

    func onAppear() {
        viewModel.requestLocationAccess()
        viewModel.loadLastSearchedCity()
    }
}
