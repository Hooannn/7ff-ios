//
//  Toast.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import UIKit
final class Toast {
    public static let shared = Toast()
    
    func display(with message: String?) {
        if let rootWindow = UIApplication.shared.windows.first {
            rootWindow.displayToast(with: "\(message ?? "Something went wrong")")
        }
    }
}
