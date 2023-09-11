//
//  OrdersStatusFilterView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import UIKit

protocol OrdersStatusFilterViewDelegate: AnyObject {
    func didSelectStatus(_ status: OrderStatus)
}

final class OrdersStatusFilterView: BaseCollectionView {
    weak var orderStatusFilterViewDelegate: OrdersStatusFilterViewDelegate?
    private let identifier = "OrderStatuses"
    private let statuses: [OrderStatus] = [.All, .Processing, .Delivering, .Done, .Cancelled]
    var selectedStatus: OrderStatus?
    {
        didSet {
            guard let selectedStatus = selectedStatus else { return }
            orderStatusFilterViewDelegate?.didSelectStatus(selectedStatus)
        }
    }
    convenience init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, delegate: OrdersStatusFilterViewDelegate) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.orderStatusFilterViewDelegate = delegate
        self.prepare()
    }
    
    override func setupViews() {
        dataSource = self
        delegate = self
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(CategoryViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    private func prepare() {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        selectItem(at: firstIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        selectedStatus = .All
    }
}

extension OrdersStatusFilterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statuses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryViewCell
        let status = statuses[indexPath.item]
        cell.label.text = status.rawValue
        if status == selectedStatus {
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryViewCell
        let text: String = statuses[indexPath.item].rawValue
        let textSize = text.size(withAttributes: [
            NSAttributedString.Key.font: cell.label.font ?? UIFont.boldSystemFont(ofSize: 16)
        ])
        return CGSize(width: textSize.width + 5, height: textSize.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.isSelected = true
            let status = statuses[indexPath.item]
            selectedStatus = status
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.isSelected = false
        }
    }
}
