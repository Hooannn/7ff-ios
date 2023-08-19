//
//  SearchViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 19/08/2023.
//

import UIKit
final class SearchViewController: UIViewController {

    override func viewDidLoad() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        title = "Search"
    }
    
    private func setupConstraints() {
        
    }
}
