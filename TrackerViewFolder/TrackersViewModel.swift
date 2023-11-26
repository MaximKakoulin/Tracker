//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Максим on 24.11.2023.
//

import Foundation

class TrackersViewModel {
    
    //MARK: - Private Properties
    private let trackerDataController: TrackerDataControllerProtocol
    private var visibleCategories: [TrackerCategory] = []
    
    
    init(trackerDataController: TrackerDataControllerProtocol) {
        self.trackerDataController = trackerDataController
    }
}
