import UIKit

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the main scroll view
        view.backgroundColor = .systemBackground
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Create a container view to hold the subviews
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Create the first subview (normal UIView)
        let normalView = UIView()
        normalView.translatesAutoresizingMaskIntoConstraints = false
        normalView.backgroundColor = .red
        containerView.addSubview(normalView)
        
        NSLayoutConstraint.activate([
            normalView.topAnchor.constraint(equalTo: containerView.topAnchor),
            normalView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            normalView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            normalView.heightAnchor.constraint(equalToConstant: 200) // Adjust the height as needed
        ])
        
        // Create the second subview (horizontally scrollable UIStackView)
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: normalView.bottomAnchor, constant: 16), // Adjust the spacing as needed
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 100), // Adjust the height as needed
        ])
        
        // Add some subviews to the stack view
        for i in 1...10 {
            let subview = UIView()
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.backgroundColor = .blue
            stackView.addArrangedSubview(subview)
            
            subview.widthAnchor.constraint(equalToConstant: 100).isActive = true // Adjust the width as needed
            subview.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        }
    }
}
