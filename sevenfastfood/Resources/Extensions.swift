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
