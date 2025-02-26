/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Orthogonal scrolling section example
*/

import UIKit

class OrthogonalScrollingViewController: UIViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    let smallCellContent = "This cell contains the content that is bigger than the estimated height (50.0) set in the layout creation. When the section is half visible, scrolling to next items in the carousel doesn't render the item. We have to scroll the carousle to make the item visible. This issue happens when we have content size more than the estimated height"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Orthogonal Sections"
        configureHierarchy()
        configureDataSource()
    }
}

extension OrthogonalScrollingViewController {
    
    //   +-----------------------------------------------------+
    //   | +---------------------------------+  +-----------+  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |     1     |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  +-----------+  |
    //   | |               0                 |                 |
    //   | |                                 |  +-----------+  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |     2     |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | +---------------------------------+  +-----------+  |
    //   +-----------------------------------------------------+
    
    /// - Tag: Orthogonal
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let estimatedHeight = 100.0
            let widthDimension: NSCollectionLayoutDimension = .fractionalWidth(1.0)
            let heightDimension = NSCollectionLayoutDimension.uniformAcrossSiblings(estimate: estimatedHeight)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: .estimated(estimatedHeight))
            
            let itemSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
            return section
            
        }
        return layout
    }
}

extension OrthogonalScrollingViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.text = "\(indexPath.section), \(indexPath.item) \(self.smallCellContent)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.lineBreakMode = .byWordWrapping
            cell.label.numberOfLines = 0
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 5
        for section in 0..<10{
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension OrthogonalScrollingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
