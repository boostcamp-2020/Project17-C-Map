//
//  PreviewViewController.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/08.
//

//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var poiService: POIServicing?
    private var placeInfoService: PlaceInfoServicing?
    private var cluster: Cluster?
    private var places: [Place] = []
    private var categories: [String] = []
    private var dataSource: UICollectionViewDiffableDataSource<String, Place>! = nil
    
    init?(coder: NSCoder, cluster: Cluster, poiService: POIServicing, placeInfoService: PlaceInfoServicing) {
        super.init(coder: coder)
        self.cluster = cluster
        self.poiService = poiService
        self.placeInfoService = placeInfoService
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        places = cluster?.coordinates.compactMap {
//            poiService?.fetch(coordinate: $0)
//        } ?? []
        
        let urls = [ "http://ldb.phinf.naver.net/20190110_293/1547048398707IGmBs_JPEG/scXaoTP-_ccxbMqn2vFL-k-G.jpg",
                     "http://ldb.phinf.naver.net/20190616_192/1560681495671CW2VX_JPEG/pPfSjNLsKKvdhYcaTkyabjtZ.jpg",
                     "http://ldb.phinf.naver.net/20190806_213/1565088665739jPvCP_JPEG/GemsLMNPxqYN0yRFOigiabqz.jpg" ]
        
        
        cluster?.coordinates.enumerated().forEach { index, coord in
            let place = Place(coordinate: coord, info: POIInfo(name: "양꼬치엔", imageUrl: urls[index%3], category: "칭따오!"))
            places.append(place)
        }
        
        categories = Array(Set(places.compactMap { $0.info.category }))
        collectionView.collectionViewLayout = createLayout()
        collectionView.showsVerticalScrollIndicator = false
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                        widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 0)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .fractionalHeight(0.2)), subitem: leadingItem, count: 1)
            containerGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = Configuration.type
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
            
        }, configuration: config)
//        })
        return layout
    }
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<String, Place>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Place) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Configuration.infoIdentifier,
                                                                for: indexPath) as? PlaceCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(place: identifier)
            
            self.placeInfoService?.fetchAdrress(lat: identifier.coordinate.y, lng: identifier.coordinate.x, completion: {
                cell.configure(address: $0)
            })
            
            if let url = identifier.info.imageUrl {
                self.placeInfoService?.fetchImage(url: url, completion: {
                    cell.configure(image: $0)
                })
            }
            
            return cell
            
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: Configuration.headerIdentifier,
                                                                                      for: indexPath) as? PlaceHeaderView else {
                return UICollectionReusableView()
            }
            
            sectionHeader.configure(text: self.categories[indexPath.section])
            
            return sectionHeader
        }
        
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, Place>()
        
        categories.forEach { category in
            snapshot.appendSections([category])
            let filtered = places.filter { $0.info.category == category }
            snapshot.appendItems(filtered)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

private extension PreviewViewController {
    
    enum Configuration {
        static let headerElementKind = "header-element-kind"
        static let headerIdentifier = "PlaceHeaderView"
        static let infoIdentifier = "PlaceCell"
        static let type = UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
