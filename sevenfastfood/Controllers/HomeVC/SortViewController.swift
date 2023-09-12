//
//  FilterViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 12/09/2023.
//

import UIKit

enum SortOption: String {
    case ascendingPrice = "Price: High to low", descendingPrice = "Price: Low to high", ascendingViews = "Views: High to low", descendingViews = "Views: Low to high"
}

protocol SortViewControllerDelegate: AnyObject {
    func didSelectOption(_ option: SortOption)
    func didClearOption()
}

final class SortViewController: UIViewController {
    weak var delegate: SortViewControllerDelegate?
    private let options: [SortOption] = [
        .ascendingPrice,
        .descendingPrice,
        .ascendingViews,
        .descendingViews
    ]
    
    private var selectedOption: SortOption?
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton(_:)))
        button.tintColor = Tokens.shared.primaryColor
        return button
    }()
    
    private lazy var clearButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(didTapClearButton(_:)))
        button.tintColor = Tokens.shared.primaryColor
        return button
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    convenience init(delegate: SortViewControllerDelegate? = nil, selectedOption: SortOption? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        if let selectedOption = selectedOption {
            self.selectedOption = selectedOption
        } else {
            self.selectedOption = options.first
        }
        
        if let row = options.firstIndex(where: { option in option == self.selectedOption}) {
            pickerView.selectRow(row as Int, inComponent: 0, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        title = "Sort by"
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = clearButton

        
        view.addSubview(pickerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc
    private func didTapDoneButton(_ sender: UIButton) {
        dismiss(animated: true)
        if let selectedOption = self.selectedOption {
            self.delegate?.didSelectOption(selectedOption)
        }
    }
    
    @objc
    private func didTapClearButton(_ sender: UIButton) {
        dismiss(animated: true)
        self.delegate?.didClearOption()
    }
}

extension SortViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let option = options[row]
        return option.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let option = options[row]
        selectedOption = option
    }
}
