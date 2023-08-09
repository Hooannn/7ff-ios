//
//  Widgets.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit


final class Widgets {
    public static let shared = Widgets()    
    private let tokens = Tokens.shared

    func createSecondaryButton(title _title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = tokens.onSecondaryColor
        button.backgroundColor = tokens.secondaryColor
        button.setTitle(_title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
}
