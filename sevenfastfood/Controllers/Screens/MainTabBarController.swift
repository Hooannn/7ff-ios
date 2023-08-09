//
//  MainTabBarController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit


struct Tab {
    private let viewController: UIViewController
    private let tag: Int
    private let image: UIImage?
    private var navigation: UINavigationController?
    
    
    init(viewController: UIViewController, tag: Int, image: UIImage?) {
        self.viewController = viewController
        self.tag = tag
        self.image = image
        setup()
    }
    
    private mutating func setup() {
        let navigation = UINavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(title: nil, image: image, tag: tag)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem = tabBarItem
        navigation.navigationItem.largeTitleDisplayMode = .automatic
        self.navigation = navigation
    }
    
    public func buildNavigation() -> UINavigationController {
        return self.navigation!
    }
}
final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigations()
    }
    
    private func setupNavigations() {
        let homeVC = HomeViewController()
        let notificationsVC = NotificationsViewController()
        let cartVC = CartViewController()
        let profileVC = ProfileViewController()
        
        let homeTab = Tab(viewController: homeVC, tag: 1, image: UIImage(named: "Home"))
        let cartTab = Tab(viewController: cartVC, tag: 2, image: UIImage(named: "Cart"))
        let notificationsTab = Tab(viewController: notificationsVC, tag: 3, image: UIImage(named: "Notifications"))
        let profileTab = Tab(viewController: profileVC, tag: 4, image: UIImage(named: "Profile"))
        
        let navigations = [homeTab, cartTab, notificationsTab, profileTab].map { tab -> UINavigationController in tab.buildNavigation()
        }
        
        tabBar.tintColor = Tokens.shared.primaryColor
        setViewControllers(navigations, animated: true)
    }
}
