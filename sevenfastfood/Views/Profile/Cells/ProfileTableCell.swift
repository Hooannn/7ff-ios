//
//  ProfileTableCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 03/09/2023.
//

import UIKit

final class ProfileTableCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(hasValue: Bool, readonly: Bool, sectionIdentifier: ProfileSectionIdentifier?, reuseIdentifier: String?) {
        let style: UITableViewCell.CellStyle = hasValue ? .value1 : .default
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        if style == .default && sectionIdentifier != .danger {
            accessoryType = .disclosureIndicator
        }
        if sectionIdentifier == .danger {
            textLabel?.textColor = .systemRed
        }
        if readonly {
            isUserInteractionEnabled = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
