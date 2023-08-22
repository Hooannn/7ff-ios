//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation

final class OnboardingViewModel {
    public func fetchOnboardingScreens() -> [OnboardingScreen] {
        LocalData.shared.getOnboardingScreens()
    }
}
