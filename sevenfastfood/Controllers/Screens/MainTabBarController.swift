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
        navigation.navigationBar.prefersLargeTitles = false
        navigation.tabBarItem = tabBarItem
        navigation.navigationBar.tintColor = Tokens.shared.primaryColor
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
        setupData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupNotificationCenter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeNotificationCenter()
    }
    
    private func setupData() {
        self.didReceiveCartUpdateNotification()
        self.didReceiveOrdersUpdateNotification()
        CartService.shared.fetchItems()
        OrdersService.shared.fetch()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCartUpdateNotification(_:)), name: NSNotification.Name.didSaveCart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveOrdersUpdateNotification(_:)), name: NSNotification.Name.didSaveOrders, object: nil)
    }
    
    private func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.didSaveCart, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.didSaveOrders, object: nil)
    }
    
    @objc func didReceiveCartUpdateNotification(_ notification: NSNotification? = nil) {
        let cartItems = LocalData.shared.getUserCart()
        let badgeValue = cartItems?.count
        let cartTab = tabBar.items?.first(where: { tab in tab.tag == 2 })
        cartTab?.badgeValue = String(badgeValue ?? 0)
    }
    
    @objc func didReceiveOrdersUpdateNotification(_ notification: NSNotification? = nil) {
        let orders = LocalData.shared.getOrders()
        let badgeValue = orders?.filter {
            order in
            order.status != .Done && order.status != .Cancelled
        }.count
        let ordersTab = tabBar.items?.first(where: { tab in tab.tag == 3 })
        ordersTab?.badgeValue = String(badgeValue ?? 0)
    }

    private func setupNavigations() {
        let homeVC = HomeViewController()
        let ordersVC = MyOrdersViewController()
        let cartVC = CartViewController()
        let profileVC = ProfileViewController()
        
        let homeTab = Tab(viewController: homeVC, tag: 1, image: UIImage(named: "Home"), title: "Home")
        let cartTab = Tab(viewController: cartVC, tag: 2, image: UIImage(named: "Cart"), title: "Cart")
        let ordersTab = Tab(viewController: ordersVC, tag: 3, image: UIImage(named: "Orders"), title: "Orders")
        let profileTab = Tab(viewController: profileVC, tag: 4, image: UIImage(named: "Profile"), title: "Profile")
        
        let navigations = [homeTab, cartTab, ordersTab, profileTab].map { tab -> UINavigationController in tab.buildNavigation()
        }
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = Tokens.shared.primaryColor
        setViewControllers(navigations, animated: true)
    }
}
