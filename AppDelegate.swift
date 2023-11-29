//
//  AppDelegate.swift
//  Tracker
//
//  Created by Максим on 28.06.2023.
//

import UIKit
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "e028fa65-ede2-4919-89e6-3e2255589e73") else {
            return true
        }

        YMMYandexMetrica.activate(with: configuration)
        return true
    }
}

