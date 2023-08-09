//
//  Tokens.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class Tokens {
    public static let shared = Tokens()
    
    let primaryColor: UIColor = {
        let color = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(190.0/255.0), blue: CGFloat(51.0/255.0), alpha: CGFloat(1.0))
        return color
    }()
    
    let secondaryColor: UIColor = {
        let color = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(40.0/255.0), blue: CGFloat(49.0/255.0), alpha: CGFloat(1.0))
        return color
    }()
    
    let onPrimaryColor: UIColor = {
        .white
    }()

    let onSecondaryColor: UIColor = {
        .white
    }()
    
    let buttonCornerRadius = CGFloat(50) // Pill button
    
    let titleFontSize = CGFloat(24)
    
    let descriptionFontSize = CGFloat(14)
}
