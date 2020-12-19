//
//  MainTabBarController.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 19.12.2020.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainVC = UINavigationController(rootViewController: MainController())
        let reservationListVC = UINavigationController(rootViewController: ReservationListController())


        mainVC.title = "Home"
        reservationListVC.title = "Reservation List"
        viewControllers = [mainVC, reservationListVC]

        guard let items = self.tabBar.items else {
            return
        }
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "gear")

    }
}
