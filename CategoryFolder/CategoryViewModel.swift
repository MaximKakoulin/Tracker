//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Максим on 19.11.2023.
//

import Foundation

final class CategoryViewModel {

    private let trackerCategoryStore: TrackerCategoryStore
    @Observable private(set) var categories: [TrackerCategoryCoreData] = []
    @Observable private(set) var selectedCategory: TrackerCategoryCoreData?

    var numberOfCategories: Int { categories.count }


    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
    }


    func fetchAllTrackerCategories() {
        /// Здесь просто вызываем метод fetchTrackerCategoriesFor у TrackerDataController
        let fetchedResultsController = trackerCategoryStore.fetchResultControllerForCategory
        categories = fetchedResultsController.fetchedObjects ?? []
    }

    func selectCategory(at indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        self.selectedCategory = selectedCategory
    }
}
