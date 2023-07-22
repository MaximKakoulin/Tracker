//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Максим on 16.07.2023.
//

import UIKit

//MARK: - Сущность для хранения записи о том, что некоторые трекер был выполнен в некоторую дату
struct TrackerRecord {
    let id: UUID
    let date: String
}

extension TrackerRecord: Hashable {
    func hush(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
