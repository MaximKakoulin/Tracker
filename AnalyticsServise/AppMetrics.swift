//
//  AppMetrics.swift
//  Tracker
//
//  Created by Максим on 29.11.2023.
//

import Foundation
import YandexMobileMetrica


protocol AppMetricsProtocol {
    func reportEvent(screen: String, event: AppMetricsParams.Event, item: AppMetricsParams.Item?)
}

class AppMetrics: AppMetricsProtocol {
    func reportEvent(screen: String, event: AppMetricsParams.Event, item: AppMetricsParams.Item?) {
        var parameters = ["screen" : screen]
        if let item {
            paramenters["item"] = item.rawValue
         }
        print("Event:", event.rawValue, parameters)
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: paramenters)
    }
}
