//
//  OrderDetailsDetails.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 11/09/2023.
//

import UIKit
final class OrderDetailsDetailsView: BaseView {
    var items = ["Placed at", "Last updated at", "Total (shipping included)", "Delivery address", "Delivery phone"]
    var data: [Int: String] = [
        0: "--",
        1: "--",
        2: "--",
        3: "--",
        4: "--",
    ]
    private let identifier = "OrderDetailsDetail"
    private lazy var titleLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.text = "Order details"
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        return label
    }()

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.rowHeight = UITableView.automaticDimension;
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.estimatedRowHeight = 32
        view.alwaysBounceVertical = false
        view.separatorStyle = .none
        return view
    }()
    
    override func setupViews() {
        layer.cornerRadius = 12
        backgroundColor = .white
        addSubviews(titleLabel, tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
        heightAnchor.constraint(equalToConstant: 24 + tableView.estimatedRowHeight * CGFloat(items.count + 1)).isActive = true
        
        layoutIfNeeded()
    }
}

extension OrderDetailsDetailsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        cell.textLabel?.text = items[indexPath.item]
        cell.textLabel?.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        cell.textLabel?.textColor = UIColor.systemGray
        cell.detailTextLabel?.text = data[indexPath.item]
        cell.detailTextLabel?.textColor = Tokens.shared.secondaryColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        32
    }
}
