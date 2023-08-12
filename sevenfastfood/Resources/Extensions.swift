//
//  Extensions.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit


extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach( {
            view in addSubview(view)
        } )
    }
}


extension UIWindow {
    func displayToast(with message: String) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = Tokens.shared.buttonCornerRadius
        label.text = message
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        label.layer.zPosition = 999
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: self.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            NSLayoutConstraint.activate([
                label.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24),
                label.heightAnchor.constraint(equalToConstant: 50)
            ])
            self.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: self.bottomAnchor),
                    label.heightAnchor.constraint(equalToConstant: 50)
                ])
                self.layoutIfNeeded()
            }, completion: { _ in
                label.removeFromSuperview()
            })
        })
    }
}
