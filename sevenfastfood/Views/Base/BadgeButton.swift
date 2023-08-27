//
//  BadgeButton.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 27/08/2023.
//

import UIKit
class BadgeButton: UIButton {
    var badgeValue: Int = 0
    {
        didSet {
            badgeLabel.text = "\(badgeValue)"
            badgeView.isHidden = badgeValue <= 0
        }
    }
    
    private lazy var badgeLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        return label
    }()
    
    private lazy var badgeView: BaseView = {
        let view = BaseView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 10
        view.layer.zPosition = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBadgeView()
    }
    
    private func setupBadgeView() {
        addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeView.heightAnchor.constraint(equalToConstant: 20),
            badgeView.widthAnchor.constraint(equalToConstant: 20),
            badgeView.topAnchor.constraint(equalTo: topAnchor, constant: -5),
            badgeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            
            badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
