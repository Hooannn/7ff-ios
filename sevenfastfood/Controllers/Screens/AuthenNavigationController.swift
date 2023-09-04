//
//  AuthenViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit


final class AuthenNavigationController: UINavigationController {
    override init(rootViewController: UIViewController = OnboardingViewController()) {
        super.init(rootViewController: rootViewController)
        navigationBar.tintColor = Tokens.shared.primaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
