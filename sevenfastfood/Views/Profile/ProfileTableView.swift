//
//  ProfileTableView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 02/09/2023.
//

import UIKit
class ProfileTableView: UITableView {
    var items = ["Good", "Thing", "To", "Know"]
    
    private var identifier = "ProfileTable"

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
}

extension ProfileTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Anything"
    }
}
