import UIKit

class SearchViewController: KeyboardAvoidViewController {
    private lazy var safeAreaInsets = Tokens.shared.safeAreaInsets
    private let debouncer = Debouncer(delay: 0.5)
    private lazy var viewModel: SearchViewModel = {
        SearchViewModel(delegate: self)
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchBarView: SearchSearchBarView = {
        let searchBar = SearchSearchBarView(delegate: self)
        return searchBar
    }()
    
    private lazy var searchResultsView: SearchResultsView = {
        let view = SearchResultsView()
        view.searchItemCellDelegate = self
        return view
    }()
    
    private var originalContainerBottomConstraint: NSLayoutConstraint?
    private var keyboardContainerBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsView.searchTextField = searchBarView.searchTextField
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        keyboardContainerBottomConstraint?.isActive = false
        originalContainerBottomConstraint?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardContainerBottomConstraint == nil {
                keyboardContainerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            }
            keyboardContainerBottomConstraint?.isActive = true
            originalContainerBottomConstraint?.isActive = false
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        containerView.addSubviews(searchBarView, searchResultsView)
        view.addSubview(containerView)
        originalContainerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Tokens.shared.containerXPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            
            searchBarView.topAnchor.constraint(equalTo: containerView.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            
            searchResultsView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 12),
            searchResultsView.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor),
            searchResultsView.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor),
            searchResultsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        originalContainerBottomConstraint?.isActive = true
    }
}

extension SearchViewController: SearchViewModelDelegate, SearchSearchBarViewDelegate, SearchItemCellDelegate {
    func didTapOnProduct(withId productId: String?) {
        guard let productId = productId else { return }
        let productDetailVC = ProductDetailViewController(productId: productId, wasPresented: false)
        pushViewControllerWithoutBottomBar(productDetailVC)
    }
    
    func didTapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func searchTextFieldDidChange(_ sender: UITextField) {
        self.searchResultsView.isLoadingOrTyping = true
        self.debouncer.debounce {
            if let text = sender.text, sender.hasText {
                self.searchResultsView.isLoadingOrTyping = true
                self.viewModel.searchProducts(withText: text)
            } else {
                self.searchResultsView.items = []
                self.searchResultsView.isLoadingOrTyping = false
            }
        }
    }
    
    func didSearchProductsSuccess(_ products: [Product]?) {
        searchResultsView.items = products
        self.searchResultsView.isLoadingOrTyping = false
    }
    
    func didSearchProductsFailure(_ error: Error) {
        self.searchResultsView.isLoadingOrTyping = false
        Toast.shared.display(with: "Search error due to \(error.localizedDescription)")
    }
}
