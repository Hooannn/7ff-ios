//
//  ProfileTableView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 02/09/2023.
//
fileprivate struct SectionItem {
    let `for`: ProfileSectionIdentifier
    let items: [ProfileSectionItem]
}

import UIKit
class ProfileTableView: UITableView {
    var viewModel: ProfileViewModel?
    private var identifier = "ProfileTable"
    private var sections: [ProfileSection]?
    private var sectionItems: [SectionItem]?
    var didTapItemWithIdentifier: ((_ identifier: ProfileSectionItemIdentitier, _ defaultValue: String?, _ title: String, _ isEmpty: Bool) -> Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    convenience init(viewModel: ProfileViewModel, frame: CGRect, style: UITableView.Style) {
        self.init(frame: frame, style: style)
        self.viewModel = viewModel
        setupViews()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTable() {
        setupDataSource()
        reloadData()
    }
    
    private func setupViews() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    private func setupDataSource() {
        sections = viewModel?.getProfileSections()
        sectionItems = self.sections?.compactMap {
            section in
            let id = section.identifier
            let items = viewModel?.getProfileItemsBySection(for: id) ?? []
            return SectionItem(for: id, items: items)
        }
    }
    
    private func getItemForIndexPath(_ indexPath: IndexPath) -> ProfileSectionItem {
        let section = sections?[indexPath.section]
        let items = sectionItems?.first(where: { sectionItem in sectionItem.for == section?.identifier })?.items ?? []
        let item = items[indexPath.row]
        return item
    }
}

extension ProfileTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let targetSection = sections?[section]
        let items = sectionItems?.first(where: { sectionItem in sectionItem.for == targetSection?.identifier })?.items
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections?[indexPath.section]
        let item = getItemForIndexPath(indexPath)
        let cell = ProfileTableCell(hasValue: item.hasValue, readonly: item.readonly, sectionIdentifier: section?.identifier, reuseIdentifier: identifier)
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.defaultValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let targetSection = sections?[section]
        return targetSection?.title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = getItemForIndexPath(indexPath)
        didTapItemWithIdentifier?(item.identifier, item.defaultValue, item.title, item.isEmpty ?? false)
        // For flash animation
        deselectRow(at: indexPath, animated: true)
    }
}
