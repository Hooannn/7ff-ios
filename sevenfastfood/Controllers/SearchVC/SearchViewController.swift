import UIKit

class SearchViewController: UIViewController {
    private lazy var safeAreaInsets = Tokens.shared.safeAreaInsets
    private let debouncer = Debouncer(delay: 0.5)
    private lazy var viewModel: SearchViewModel = {
        SearchViewModel(delegate: self)
    }()
    
    private var isTyping: Bool = false
    {
        didSet {
            if isTyping {
                debugPrint("Typing")
            } else {
                debugPrint("End Typing")
            }
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchBarView: SearchSearchBarView = {
        let searchBar = SearchSearchBarView(delegate: self)
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        containerView.addSubviews(searchBarView)
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
        ])
    }
}

extension SearchViewController: SearchViewModelDelegate, SearchSearchBarViewDelegate {
    func didTapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func searchTextFieldDidChange(_ sender: UITextField) {
        self.isTyping = true
        self.debouncer.debounce {
            if let text = sender.text, sender.hasText {
                debugPrint("Text -> \(text)")
                self.viewModel.searchProducts(withText: text)
            }
            self.isTyping = false
        }
    }
    
    func didSearchProductsSuccess(_ products: [Product]?) {
        debugPrint("Search success -> \(products)")
    }
    
    func didSearchProductsFailure(_ error: Error) {
        Toast.shared.display(with: "Search error due to \(error.localizedDescription)")
    }
}
