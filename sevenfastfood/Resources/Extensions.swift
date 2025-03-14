//
//  Extensions.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit
import IQKeyboardManagerSwift
extension UIImageView {
    func loadRemoteUrl(from url: String?) {
        guard let url, let parsedUrl = URL(string: url) else {
            return
        }
        let cacheId = NSString(string: url)
        image = nil
        if let cachedData = LocalData.shared.imageCache.object(forKey: cacheId) {
            DispatchQueue.main.async { [weak self] in self?.image = UIImage(data: cachedData as Data) }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showAnimatedGradientSkeleton()
            }
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: parsedUrl)
                    LocalData.shared.imageCache.setObject(data as NSData, forKey: cacheId)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                        self?.hideSkeleton()
                    }
                } catch {
                    Toast.shared.display(with: "Error when loading remote image: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension UIViewController {
    func changeScene(to screen: Screen) -> Void {
        if let scene = UIApplication.shared.connectedScenes.first, let sd: SceneDelegate = (scene.delegate as? SceneDelegate) {
            sd.changeScreen(to: screen)
        }
    }
    
    func pushViewControllerWithoutBottomBar(_ vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSearchViewController() {
        let searchVC = SearchViewController()
        let navigationVC = UINavigationController(rootViewController: searchVC)
        navigationVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navigationVC, animated: true)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach( {
            view in addSubview(view)
        } )
    }
}

extension UIWindow {
    func displayToast(with message: String) {
        let containerView = UIView()
        let label = UILabel()
        let isKeyboardShowing = IQKeyboardManager.shared.keyboardShowing
        let keyboardFrame = IQKeyboardManager.shared.keyboardFrame
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = Tokens.shared.buttonCornerRadius
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = message
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        label.layer.zPosition = 999
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        let toastHideBottomAnchor: NSLayoutConstraint = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 50)
        let bottomConstant = isKeyboardShowing ? keyboardFrame.height : 24
        let toastShowBottomAnchor: NSLayoutConstraint = containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -CGFloat(bottomConstant))
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            containerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        toastHideBottomAnchor.isActive = true
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            toastShowBottomAnchor.isActive = true
            self.layoutIfNeeded()
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                    toastShowBottomAnchor.isActive = false
                    toastHideBottomAnchor.isActive = true
                    self.layoutIfNeeded()
                }, completion: { _ in
                    containerView.removeFromSuperview()
                })
            })
        })
    }
}

extension UIButton {
    func setLoading(_ isLoading: Bool) {
        let tag = 808404
        if isLoading {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

extension UIImageView {
    func setLoading(_ isLoading: Bool) {
        let tag = 801404
        if isLoading {
            self.isUserInteractionEnabled = false
            self.alpha = 0.8
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            indicator.color = Tokens.shared.primaryColor
            self.addSubview(indicator)
            self.bringSubviewToFront(indicator)
            indicator.startAnimating()
        } else {
            self.isUserInteractionEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

extension NSNotification.Name {
    static var didSaveCart: Notification.Name {
        return .init(rawValue: "Cart.updated") }
    static var didSaveUser: Notification.Name {
        return .init(rawValue: "User.updated")
    }
    static var didSaveOrders: Notification.Name {
        return .init(rawValue: "Orders.updated")
    }
}
