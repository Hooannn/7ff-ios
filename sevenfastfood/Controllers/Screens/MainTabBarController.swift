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
    private let title: String?
    private var navigation: UINavigationController?
    
    
    init(viewController: UIViewController, tag: Int, image: UIImage?, title: String?) {
        self.viewController = viewController
        self.tag = tag
        self.title = title
        self.image = image
        setup()
    }
    
    private mutating func setup() {
        let navigation = UINavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem = tabBarItem
        navigation.navigationItem.largeTitleDisplayMode = .never
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
        
        CartService.shared.fetchItems()
    }
    
    private func setupNavigations() {
        let homeVC = HomeViewController()
        let notificationsVC = NotificationsViewController()
        let cartVC = CartViewController()
        let profileVC = ProfileViewController()
        
        let homeTab = Tab(viewController: homeVC, tag: 1, image: UIImage(named: "Home"), title: "Home")
        let cartTab = Tab(viewController: cartVC, tag: 2, image: UIImage(named: "Cart"), title: "Cart")
        let notificationsTab = Tab(viewController: notificationsVC, tag: 3, image: UIImage(named: "Notifications"), title: "Messages")
        let profileTab = Tab(viewController: profileVC, tag: 4, image: UIImage(named: "Profile"), title: "Profile")
        
        let navigations = [homeTab, cartTab, notificationsTab, profileTab].map { tab -> UINavigationController in tab.buildNavigation()
        }
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = Tokens.shared.primaryColor
        setViewControllers(navigations, animated: true)
    }
}
