//
//  Array+Subscript.swift
//  Tracker
//
//  Created by Максим on 29.11.2023.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
