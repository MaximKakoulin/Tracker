//
//  Tracker.swift
//  Tracker
//
//  Created by Максим on 16.07.2023.
//

import UIKit

//MARK: - Сущность для хранения информации про трекер
struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Int]
    let isEvent: Bool
    var isPinned: Bool
    var category: String
    var previousCategory: String?
}
