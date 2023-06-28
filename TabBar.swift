//
//  TabBar.swift
//  Tracker
//
//  Created by Максим on 28.06.2023.
//

import UIKit


final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBarViewController()
    }

    private func createTabBarViewController() {
        tabBar.isTranslucent = false
        tabBar.barTintColor = .YPBlue
        tabBar.tintColor = .YPWhite

        let trackerViewController = TrackerViewController()
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)

        trackerViewController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                       image: UIImage(named: "Record_circle_fill"),
                                                       selectedImage: nil
                                                       )
        trackerViewController.tabBarItem.accessibilityIdentifier = "TrackerView"

        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                          image: UIImage(named: "Hare_fill"),
                                                          selectedImage: nil
                                                          )
        statisticViewController.tabBarItem.accessibilityIdentifier = "StatisticView"

        self.viewControllers = [trackerNavigationController, statisticViewController]
    }
}
