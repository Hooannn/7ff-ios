//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let widgets = Widgets.shared
    private lazy var viewModel: ProfileViewModel = {
        ProfileViewModel(delegate: self)
    }()
    
    private var user: User?
    {
        didSet {
            if let avatar = user?.avatar {
                avatarView.avatar = avatar
            }
            if let firstName = user?.firstName, let lastName = user?.lastName {
                avatarView.displayName = "\(firstName) \(lastName)"
            }
            tableView.reloadTable()
        }
    }
    
    private lazy var avatarView: ProfileAvatarView = {
        let view = ProfileAvatarView()
        view.didTapAvatar = {
            self.presentImagePickerActionSheet()
        }
        return view
    }()
    
    private lazy var tableView: ProfileTableView = {
        let table = ProfileTableView(viewModel: self.viewModel, frame: .zero, style: .insetGrouped)
        table.didTapItemWithIdentifier = {
            identifier, defaultValue, title, isEmpty in
            switch identifier {
            case .address, .firstName, .email, .phoneNumber, .lastName:
                let viewController = UpdateSingleFieldViewController(for: identifier, defaultValue: defaultValue ?? "", isEmpty: isEmpty, needConfirmation: false)
                viewController.title = title
                viewController.delegate = self
                self.pushViewControllerWithoutBottomBar(viewController)
            case .password:
                let viewController = UpdateSingleFieldViewController(for: identifier, defaultValue: defaultValue ?? "", isEmpty: isEmpty, needConfirmation: true)
                viewController.title = title
                viewController.delegate = self
                self.pushViewControllerWithoutBottomBar(viewController)
            case .orders:
                let viewController = MyOrdersViewController()
                self.pushViewControllerWithoutBottomBar(viewController)
            case .reservations:
                let viewController = MyReservationsViewController()
                self.pushViewControllerWithoutBottomBar(viewController)
            case .deactivateAccount:
                let viewController = DeactivateAccountViewController()
                self.pushViewControllerWithoutBottomBar(viewController)
            case .signOut:
                self.presentSignOutAlert()
            }
        }
        return table
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarView, tableView])
        stack.spacing = 12
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupInitUser()
    }
    
    private func setupInitUser() {
        viewModel.getUser {
            user in self.user = user
        }
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        title = "Profile"
        scrollView.addSubview(contentStackView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            
            avatarView.heightAnchor.constraint(equalToConstant: 140),
            tableView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }
    
    private func presentImagePickerActionSheet() {
        let actionSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let photoAction = UIAlertAction(title: "Choose a photo", style: .default) {
            _ in
            self.presentImagePicker(with: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take new photo", style: .default) {
            _ in
            self.presentImagePicker(with: .camera)
        }
        actionSheetVC.addAction(cameraAction)
        actionSheetVC.addAction(photoAction)
        actionSheetVC.addAction(cancelAction)
        present(actionSheetVC, animated: true)
    }
    
    private func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        
        present(imagePicker, animated: true)
    }
    
    private func presentSignOutAlert() {
        let signOutAlertVC = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let acceptAction = UIAlertAction(title: "Confirm", style: .destructive) {
            _ in self.doSignOut()
        }
        signOutAlertVC.addAction(cancelAction)
        signOutAlertVC.addAction(acceptAction)
        present(signOutAlertVC, animated: true)
    }
    
    private func doSignOut() {
        viewModel.performSignOut {
            self.changeScene(to: .auth)
        }
    }
}

extension ProfileViewController: UpdateSingleFieldViewControllerDelegate, ProfileViewModelDelegate {
    func didReceiveUserUpdate(_ user: User?) {
        self.user = user
    }
    
    func fieldDidSave(_ newValue: String, _ identifier: ProfileSectionItemIdentitier) {
        navigationController?.popViewController(animated: true)
        if identifier != .password {
            let params = [
                identifier.rawValue: newValue
            ]
            viewModel.updateProfile(params: params)
        } else {
            viewModel.changePassword(newPassword: newValue)
        }
    }
    
    func profileDidUpdateSuccess(_ updatedUser: User?) {
        Toast.shared.display(with: "Updated successfully")
    }
    
    func profileDidUpdateFailure(_ error: Error) {
        Toast.shared.display(with: "Updated profile error due to \(error.localizedDescription)")
    }
    
    func avatarDidUploadFailure(_ error: Error) {
        Toast.shared.display(with: "Upload error due to \(error.localizedDescription)")
    }
    
    func avatarUploadProgressDidUpdate(_ progress: Progress) {
        debugPrint("Avatar upload progress -> \(progress.fractionCompleted)")
    }
    
    func avatarDidUploadSuccess(_ file: File?) {
        avatarView.avatarImageView.imageView.setLoading(false)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let imageData = image?.jpegData(compressionQuality: 0.2) {
            avatarView.avatarImageView.imageView.setLoading(true)
            viewModel.changeAvatar(withImageData: imageData)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
