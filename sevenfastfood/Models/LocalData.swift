//
//  Onboarding.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation
import UIKit

struct OnboardingScreen {
    let title: String
    let description: String
    let displayImage: UIImage?
    let buttonTitle: String
    let isFinal: Bool
}

final class LocalData {
    private lazy var client = UserDefaults.standard
    public static let shared = LocalData()
    let imageCache = NSCache<NSString, NSData>()
    private let onboardingScreens: [OnboardingScreen] = [
        OnboardingScreen(title: "We Are 7ff", description: "7FF (short for 7 Fast Food) is a food chain that specialize in providing refreshment and snack as well as conventional fast food", displayImage: UIImage(named: "Onboarding_1"), buttonTitle: "Continue", isFinal: false),
        OnboardingScreen(title: "Just A Message From 7ff ...", description: "We are always aware of customers’ evolving tastes", displayImage: UIImage(named: "Onboarding_2"), buttonTitle: "Continue", isFinal: false),
        OnboardingScreen(title: "Start-Up Story Of 7ff", description: "“Don’t worry about failure, you only have to be right once” - Drew Houston", displayImage: UIImage(named: "Onboarding_3"), buttonTitle: "Let's started", isFinal: true),
    ]
    
    
    public func getOnboardingScreens() -> [OnboardingScreen] {
        onboardingScreens
    }
    
    public func setAccessToken(_ token: String) -> Void {
        client.set(token, forKey: "accessToken")
    }
    
    public func setRefreshToken(_ token: String) -> Void {
        client.set(token, forKey: "refreshToken")
    }
    
    public func setLoggedUser(_ user: User) -> Void {
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(user) {
            client.set(encodedUser, forKey: "user")
        }
    }
    
    public func getAccessToken() -> String? {
        client.string(forKey: "accessToken")
    }
    
    public func getRefreshToken() -> String? {
        client.string(forKey: "refreshToken")
    }
    
    public func getLoggedUser() -> User? {
        if let user = client.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            let decodedUser = try? decoder.decode(User.self, from: user)
            return decodedUser
        }
        return nil
    }
    
    public func cleanup() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    public func getUserCart() -> [CartItem]? {
        if let cartItems = client.object(forKey: "cartItems") as? Data {
            let decoder = JSONDecoder()
            let decoded = try? decoder.decode([CartItem].self, from: cartItems)
            return decoded
        }
        return nil
    }
    
    public func saveUserCart(cartItems: [CartItem]?) {
        let encoder = JSONEncoder()
        if let cartItems = cartItems {
            if let encoded = try? encoder.encode(cartItems) {
                client.set(encoded, forKey: "cartItems")
                NotificationCenter.default.post(name: NSNotification.Name.didSaveCart, object: nil)
            }
        }
    }
}
