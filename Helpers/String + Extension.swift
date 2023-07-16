//
//  String + Extension.swift
//  Tracker
//
//  Created by Максим on 16.07.2023.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
