//
//  PreviewViewController.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/08.
//

//

import UIKit

protocol PlaceListViewControllerDelegate: class {
    
    func selectedPlace(_ placeListViewController: PlaceListViewController, place: Place)
    
}

class PlaceListViewController: UIViewController {
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<String, Place>
    
    private let operationQueue = OperationQueue()
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var filterScrollView: FilterScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var poiService: POIServicing?
    private var placeInfoService: PlaceInfoServicing?
    private var places: [Place] = []
    private var categories: [String] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    var isShow: Bool = false
    weak var delegate: PlaceListViewControllerDelegate?
    
    private var dataSource: DiffableDataSource?
    var cancelButtonTouchedHandler: (() -> Void)?
    
    init?(coder: NSCoder, poiService: POIServicing, placeInfoService: PlaceInfoServicing) {
        super.init(coder: coder)
        self.poiService = poiService
        self.placeInfoService = placeInfoService
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame.origin.y = UIScreen.main.bounds.maxY
        configure()
        configureDataSource()
    }
    
    private func configure() {
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.collectionViewLayout = createLayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        
        let gesture = UIPanGestureRecognizer.init(target: self,
                                                  action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func requestPlaces(cluster: Cluster) {
        cancelAllOperation()
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self] in
            guard let self = self else { return }
            if operation.isCancelled { return }

            let boundingBox = cluster.boundingBox
            
            self.poiService?.fetchInfo(bottomLeft: boundingBox.bottomLeft, topRight: boundingBox.topRight) { [weak self] in
                guard let self = self else { return }
                if operation.isCancelled { return }

                self.places = $0
                self.categories = Array(Set(self.places.compactMap { $0.info.category }))

                self.filterScrollView.configure(filterItems: self.categories) { category in
                    self.moveSection(to: category)
                }
            }
        }
        operationQueue.addOperation(operation)
    }
    
    func cancelAllOperation() {
        operationQueue.cancelAllOperations()
        placeInfoService?.cancel()
    }
    
}

// MARK: - 화면 Show/Hide 애니메이션
extension PlaceListViewController {
    
    @IBAction private func placeListHideButtonTouched(_ sender: UIButton) {
        disappearAnimation { [weak self] in
            self?.cancelButtonTouchedHandler?()
        }
    }
        
    func appearAnimation() {
        guard !isShow else { return }
        
        isShow = true
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            let frame = self.view.frame
            let yComponent = Boundary.partialView
            self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
        })
    }
    
    func disappearAnimation(completion: @escaping () -> Void) {
        guard isShow else { return }
        
        isShow = false
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            let frame = self.view.frame
            let y = UIScreen.main.bounds.maxY
            self.view.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height)
        }, completion: { _ in
            completion()
        })
    }
    
    func disappear() {
        isShow = false
        let y = UIScreen.main.bounds.maxY
        view.frame = CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height)
    }
    
    func minimumHeightMode() {
        view.frame = CGRect(x: 0,
                            y: Boundary.partialView,
                            width: self.view.frame.width,
                            height: Boundary.partialView)
    }
    
}

// MARK: - collectionView
extension PlaceListViewController: UICollectionViewDelegate {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (_, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let groupHeight: CGFloat = contentSize.height > 660 ? 0.18 : 0.24
            
            let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                        widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .fractionalHeight(groupHeight)), subitem: leadingItem, count: 1)
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = Configuration.type
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(1.0),
                                                   heightDimension: .estimated(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading)
            
            sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10)
            sectionHeader.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
            
        }, configuration: config)
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = DiffableDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Place) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Configuration.infoIdentifier,
                                                                for: indexPath) as? PlaceCell
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(place: identifier)
    
            self.placeInfoService?.fetchAddress(lat: identifier.coordinate.y, lng: identifier.coordinate.x, completion: {
                cell.configure(address: $0)
            })
    
            if let url = identifier.info.imageUrl {
                self.placeInfoService?.fetchImage(url: url, completion: {
                    cell.configure(image: $0)
                })
            }
            
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: Configuration.headerIdentifier,
                                                                                      for: indexPath) as? PlaceHeaderView else {
                return UICollectionReusableView()
            }
            
            let title = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] ?? ""
            sectionHeader.configure(text: title)
            return sectionHeader
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, Place>()
        
        categories.forEach { category in
            snapshot.appendSections([category])
            let filtered = places.filter { $0.info.category == category }
            snapshot.appendItems(filtered)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func moveSection(to category: String) {
        guard let dataSource = dataSource,
              let targetSection = dataSource.snapshot().sectionIdentifiers.first,
              category != targetSection
        else {
            return
        }
        
        var newSnapshot = dataSource.snapshot()
        newSnapshot.moveSection(category, beforeSection: targetSection)
        dataSource.apply(newSnapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let selectedPlace = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        delegate?.selectedPlace(self, place: selectedPlace)
    }
    
    enum Configuration {
        static let headerElementKind = "header-element-kind"
        static let headerIdentifier = "PlaceHeaderView"
        static let infoIdentifier = "PlaceCell"
        static let type = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging
    }
    
}
