//
//  TrackerPersistentContainer.swift
//  Tracker
//
//  Created by Максим on 06.08.2023.
//

import CoreData
import Foundation

final class TrackerPersistentContainer {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerCoreData")

        // Создаем описание хранилища и добавляем опции для легкой миграции
        let description = NSPersistentStoreDescription()
        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        container.persistentStoreDescriptions = [description]

        // Загрузка хранилищ
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Ошибка инициализации контейнера CoreData: \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}

