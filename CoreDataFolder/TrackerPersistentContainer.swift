//
//  TrackerPersistentContainer.swift
//  Tracker
//
//  Created by Максим on 06.08.2023.
//

import Foundation
import CoreData


final class TrackerPersistentContainer {
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TrackerCoreData")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                fatalError("Ошибка инициализации контейнера CoreData: \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
}
