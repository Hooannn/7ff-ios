//
//  ClickableView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 19/08/2023.
//

import UIKit
class ClickableCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        setupGestureRecognizer()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupViews() {
        
    }
    
    internal func setupConstraints() {
        
    }
    
    internal func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(performTapAnimation(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didPress(_:)))
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(longPressGesture)
    }
    
    @objc func performTapAnimation(_ sender: UIGestureRecognizer) {
        animateHoverEffect {
            self.restoreOriginalState()
            self.didTap(sender)
        }
    }
    
    @objc func didTap(_ sender: UIGestureRecognizer) {
        
    }
    
    @objc func didPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case.began:
            animateHoverEffect(completion: nil)
        case .cancelled:
            restoreOriginalState()
        case .ended:
            restoreOriginalState()
            didEndLongPress()
        default:
            return
        }
    }
    
    func didEndLongPress() -> Void {
        
    }

    private func animateHoverEffect(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0.97
            self.transform = self.transform.scaledBy(x: 0.97, y: 0.97)
        }) {
            done in if done {
                completion?()
            }
        }
    }
    
    private func restoreOriginalState() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = self.transform.scaledBy(x: 1 / 0.97, y: 1 / 0.97)
        })
    }
    
}
