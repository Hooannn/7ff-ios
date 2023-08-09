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
}

final class LocalData {
    public static let shared = LocalData()
    private let onboardingScreens: [OnboardingScreen] = [
        OnboardingScreen(title: "Onboarding 1", description: "Description 1", displayImage: UIImage(named: "Onboarding_1")),
        OnboardingScreen(title: "Onboarding 2", description: "Description 2", displayImage: UIImage(named: "Onboarding_2")),
        OnboardingScreen(title: "Onboarding 3", description: "Description 3", displayImage: UIImage(named: "Onboarding_3")),
    ]
    
    
    public func getOnboardingScreens() -> [OnboardingScreen] {
        onboardingScreens
    }
}
