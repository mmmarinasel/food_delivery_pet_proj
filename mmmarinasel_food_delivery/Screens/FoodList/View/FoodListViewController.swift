import UIKit

final class FoodListViewController: UIViewController, ViewLoadable {
    
    typealias MainView = FoodListView

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
    
    override func loadView() {
        self.view = FoodListView()
    }
}
