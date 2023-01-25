import UIKit

final class FoodListView: UIView {
    enum SectionKind: Int, CaseIterable {
        case ads, categories, foodList
    }

    public var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        label.textColor = .black
        label.text = "Hello"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var menuCollectionView: UICollectionView?

//    private func setup() {
//        self.backgroundColor = .systemBackground
//        self.addSubview(self.greetingLabel)
//    }

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubview(self.greetingLabel)
        self.menuCollectionView = UICollectionView(frame: self.frame,
                                                   collectionViewLayout: createLayout())
        guard let menuCollectionView = self.menuCollectionView else { return }
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(AdCollectionViewCell.self,
                                          forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
        menuCollectionView.register(CategoryCollectionViewCell.self,
                                          forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        menuCollectionView.register(FoodCollectionViewCell.self,
                                          forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        self.addSubview(menuCollectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let menuCollectionView = self.menuCollectionView else { return }

        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            self.greetingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                        constant: 16),
            self.greetingLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                    constant: 50),
            menuCollectionView.topAnchor.constraint(equalTo: self.greetingLabel.bottomAnchor,
                                                    constant: 20),
            menuCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            menuCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - UICollectionViewLayout

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            let section = SectionKind(rawValue: sectionIndex)
            guard let section = section else { return nil }
            switch section {
            case .ads:
                return self?.createAdsSection()
            case .categories:
                return self?.createCategoriesSection()
            case .foodList:
                return self?.createFoodListSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    // MARK: - NSCollectionLayoutSection

    private func createAdsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300),
                                               heightDimension: .absolute(112))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .flexible(15)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 10,
                                                        bottom: 0,
                                                        trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }

    private func createCategoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88),
                                               heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .flexible(15)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 10,
                                                        bottom: 0,
                                                        trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }

    private func createFoodListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15,
                                                        leading: 0,
                                                        bottom: 15,
                                                        trailing: 0)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }

    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(0.5)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
}

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension FoodListView: UICollectionViewDelegate {

}

extension FoodListView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionKind.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SectionKind(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch section {
        case .ads:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.identifier,
                                                          for: indexPath) as? AdCollectionViewCell
            cell?.backgroundColor = .blue
            guard let cell = cell else { return UICollectionViewCell() }
            return cell
        case .categories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier,
                                                          for: indexPath) as? CategoryCollectionViewCell
            cell?.backgroundColor = .yellow
            guard let cell = cell else { return UICollectionViewCell() }
            return cell
        case .foodList:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier,
                                                          for: indexPath) as? FoodCollectionViewCell
            cell?.backgroundColor = .systemPink
            guard let cell = cell else { return UICollectionViewCell() }
            return cell
        }
    }
}
