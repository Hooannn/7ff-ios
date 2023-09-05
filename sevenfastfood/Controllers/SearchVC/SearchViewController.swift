import UIKit

class SearchViewController: UIViewController {
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
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsView.searchTextField = searchBarView.searchTextField
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        containerView.addSubviews(searchBarView, searchResultsView)
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Tokens.shared.containerXPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchBarView.topAnchor.constraint(equalTo: containerView.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),

            searchResultsView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 12),
            searchResultsView.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor),
            searchResultsView.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor),
            searchResultsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}

extension SearchViewController: SearchViewModelDelegate, SearchSearchBarViewDelegate {
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
