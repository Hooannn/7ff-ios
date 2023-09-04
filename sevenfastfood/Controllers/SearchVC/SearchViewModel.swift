//
//  SearchViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 19/08/2023.
//

protocol SearchViewModelDelegate: AnyObject {
    func didSearchProductsSuccess(_ products: [Product]?)
    func didSearchProductsFailure(_ error: Error)
}

final class SearchViewModel {
    weak var delegate: SearchViewModelDelegate?
    
    init(delegate: SearchViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func searchProducts(withText text: String) {
        let queryDict = [
            "$regex": text,
            "$options": "i"
        ]
        let queryString = Utils.shared.dictionaryToJson(queryDict)
        let params: [String: Any] = [
            "q": queryString ?? "",
            "locale": "en"
        ]
        ProductsService.shared.search(withParams: params) {
            result in
            switch result {
            case .success(let data):
                self.delegate?.didSearchProductsSuccess(data?.data)
            case .failure(let error):
                self.delegate?.didSearchProductsFailure(error)
            }
        }
    }
}
