//
//  Date Formatter.swift
//  Tracker
//
//  Created by Максим on 19.11.2023.
//

import Foundation

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }
}
