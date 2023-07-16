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

    //MARK: - Private Methods
    private func createTabBarViewController() {
        tabBar.backgroundColor = .YPWhite
        tabBar.isTranslucent = true
        tabBar.barTintColor = .YPWhite
        tabBar.tintColor = .YPBlue

        //Добавление полосы разделения
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowRadius = 1


        let trackerViewController = TrackersViewController()
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
