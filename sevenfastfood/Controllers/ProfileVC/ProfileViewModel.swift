//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit
import Alamofire

enum ProfileSectionIdentifier {
    case accountDetails, others, danger
}

enum ProfileSectionItemIdentitier: String {
    case firstName, lastName, email, phoneNumber, password, address, orders, reservations, deactivateAccount, signOut
}

struct ProfileSection {
    let title: String
    let identifier: ProfileSectionIdentifier
}

struct ProfileSectionItem {
    let title: String
    let subtitle: String?
    let image: UIImage?
    let identifier: ProfileSectionItemIdentitier
    let hasValue: Bool
    let defaultValue: String?
    let isEmpty: Bool?
    let readonly: Bool
}

protocol ProfileViewModelDelegate: AnyObject {
    func profileDidUpdateSuccess(_ updatedUser: User?)
    func profileDidUpdateFailure(_ error: Error)
}

final class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?
    func performSignOut(completion: @escaping () -> Void) {
        LocalData.shared.cleanup()
        completion()
    }
    
    func getUser(completion: @escaping (User?) -> Void) {
        let user = LocalData.shared.getLoggedUser()
        
        completion(user)
    }
    
    func getProfileSections() -> [ProfileSection] {
        [
            ProfileSection(title: "Account Details", identifier: .accountDetails),
            ProfileSection(title: "Others", identifier: .others),
            ProfileSection(title: "Danger", identifier: .danger)
        ]
    }
    
    func getProfileItemsBySection(for identifier: ProfileSectionIdentifier) -> [ProfileSectionItem] {
        var user: User?
        self.getUser {
            result in user = result
        }
        let firstName = user?.firstName ?? "Not updated yet"
        let lastName = user?.lastName ?? "Not updated yet"
        let address = user?.address ?? "Not updated yet"
        let phone = user?.phoneNumber ?? "Not updated yet"
        let email = user?.email ?? "Not updated yet"
        switch identifier {
        case .accountDetails:
            return [
                ProfileSectionItem(title: "First name", subtitle: nil, image: nil, identifier: .firstName, hasValue: true, defaultValue: firstName, isEmpty: user?.firstName == nil, readonly: false),
                ProfileSectionItem(title: "Last name", subtitle: nil, image: nil, identifier: .lastName, hasValue: true, defaultValue: lastName, isEmpty: user?.lastName == nil, readonly: false),
                ProfileSectionItem(title: "Address", subtitle: nil, image: nil, identifier: .address, hasValue: true, defaultValue: address, isEmpty: user?.address == nil, readonly: false),
                ProfileSectionItem(title: "Phone", subtitle: nil, image: nil, identifier: .phoneNumber, hasValue: true, defaultValue: phone, isEmpty: user?.phoneNumber == nil, readonly: false),
                ProfileSectionItem(title: "Password", subtitle: nil, image: nil, identifier: .password, hasValue: true, defaultValue: "******", isEmpty: false, readonly: false),
                ProfileSectionItem(title: "Email", subtitle: nil, image: nil, identifier: .email, hasValue: true, defaultValue: email, isEmpty: false, readonly: true)
            ]
        
        case .others:
            return [
                ProfileSectionItem(title: "Orders", subtitle: nil, image: nil, identifier: .orders, hasValue: false, defaultValue: nil, isEmpty: false, readonly: false),
                ProfileSectionItem(title: "Reservations", subtitle: nil, image: nil, identifier: .reservations, hasValue: false, defaultValue: nil, isEmpty: false, readonly: false)
            ]

        case .danger:
            return [
                ProfileSectionItem(title: "Deactivate account", subtitle: nil, image: nil, identifier: .deactivateAccount, hasValue: false, defaultValue: nil, isEmpty: false, readonly: false),
                ProfileSectionItem(title: "Sign out", subtitle: nil, image: nil, identifier: .signOut, hasValue: false, defaultValue: nil, isEmpty: false, readonly: false)
            ]
        }
    }
    
    func updateProfile(params: Parameters) {
        ProfileService.shared.update(withParams: params) {
            result in switch result {
            case .success(let data):
                self.delegate?.profileDidUpdateSuccess(data?.data)
            case .failure(let error):
                self.delegate?.profileDidUpdateFailure(error)
            }
        }
    }
    
    func changePassword(newPassword: String) {
        ProfileService.shared.changePassword(newPassword: newPassword) {
            result in switch result {
            case .success(let data):
                self.delegate?.profileDidUpdateSuccess(data?.data)
            case .failure(let error):
                self.delegate?.profileDidUpdateFailure(error)
            }
        }
    }
}
