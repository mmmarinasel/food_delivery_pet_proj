import Foundation

class FoodListModel {

    private let networkManager: NetworkManagerProtocol

    private let categoriesURL: String = "http://89.108.99.78:3000/categories"
    private let foodURL: String = "http://89.108.99.78:3000/products"

    public var categories: Categories = []
    public var menu: FoodDescriptions = []

    public init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.networkManager.getData(urlString: self.categoriesURL) { [weak self] (result: Result<Categories, Error>) in
            switch result {
            case .success(let data):
//                let categs: Categories = data
                self?.categories = data
            case .failure(let error):
                print(error)
            }
        }
    }
}
