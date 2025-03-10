//
//  Tokens.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class Tokens {
    public static let shared = Tokens()
    let textFieldFontSize = CGFloat(14)
    
    let lightBackgroundColor: UIColor = .systemGray6
    
    let primaryColor: UIColor = {
        let color = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(190.0/255.0), blue: CGFloat(51.0/255.0), alpha: CGFloat(1.0))
        return color
    }()
    
    let primaryBackgroundColor: UIColor = {
        let color = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(190.0/255.0), blue: CGFloat(51.0/255.0), alpha: CGFloat(0.1))
        return color
    }()
    
    let defaultButtonHeight = CGFloat(54)
    
    lazy var safeAreaInsets = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets
    let secondaryColor: UIColor = {
        let color = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(40.0/255.0), blue: CGFloat(49.0/255.0), alpha: CGFloat(1.0))
        return color
    }()
    
    let containerXPadding = CGFloat(32)
    
    let onPrimaryColor: UIColor = {
        .white
    }()

    let onSecondaryColor: UIColor = {
        .white
    }()
    
    let systemFontSize = CGFloat(16)
    
    let smallSystemFontSize = UIFont.smallSystemFontSize
    
    let buttonCornerRadius = CGFloat(12)
    
    let titleFontSize = CGFloat(24)
    
    let descriptionFontSize = CGFloat(14)
}
