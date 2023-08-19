//
//  ClickableView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 19/08/2023.
//

import UIKit
class ClickableCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didPress(_:)))
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(longPressGesture)
    }
    
    @objc func didTap(_ sender: UIGestureRecognizer) {
        animateHoverEffect {
            self.restoreOriginalState()
        }
    }
    
    @objc func didPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case.began:
            animateHoverEffect(completion: nil)
        case .cancelled, .ended:
            restoreOriginalState()
        default:
            return
        }
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
