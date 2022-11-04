//
//  ViewController.swift
//  PiriuCollectionTest
//

import UIKit

class ViewController: UIViewController {
	var sections: [ScrollableCollectionSections] = {
		return [
			.profileInfo,
			.content
		]
	}()

	@IBOutlet weak var collectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId)
		collectionView.reloadData()
	}
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	// MARK: - collection Items
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections[section].numberOfCells
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let section = sections[indexPath.section]
		switch sections[indexPath.section] {
		case .profileInfo:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionCell.reuseId, for: indexPath) as? TestCollectionCell else { return UICollectionViewCell(frame: .zero) }
			cell.setUp(color: .black.withAlphaComponent(CGFloat.random(in: 0.1...0.75)))
			return cell
		case .content:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionCell.reuseId, for: indexPath) as? TestCollectionCell else { return UICollectionViewCell(frame: .zero) }

			// MOC
			let view = ScrollableStackView(frame: section.getCellSize(frame: collectionView.frame))
			let tView1 = TestContentView(frame: section.getCellSize(frame: collectionView.frame))
			let tView2 = UIView(frame: section.getCellSize(frame: collectionView.frame))
			tView2.backgroundColor = .blue
			let tView3 = UIView(frame: section.getCellSize(frame: collectionView.frame))
			tView3.backgroundColor = .red
			view.setUp(items: [tView1, tView2, tView3])
			cell.setUp(with: view)
			// MOC

			return cell
		}
	}

	// MARK: - Frame/Size/header
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return sections[indexPath.section].getCellSize(frame: collectionView.frame).size
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return sections[section].getHeaderSize(frame: collectionView.frame)
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if !sections[indexPath.section].hasHeader {
			return  UICollectionReusableView()
		}
		switch kind {
			case UICollectionView.elementKindSectionHeader:
			guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseId, for: indexPath) as? HeaderView else {return UICollectionReusableView(frame: .zero)}
			headerView.setUp()
			return headerView

			default:
				assert(false, "Unexpected element kind")
			}
	}

	// MARK:- scroll handling
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		if let firstVisible = collectionView.indexPathsForVisibleItems.filter({ indexPath in
			return sections[indexPath.section].directionToScrollSectionToTop == scrollView.scrollDirection && sections[indexPath.section].autoScrollToTheTopOfDisplay
		}).first {
			collectionView.scrollToItem(at: IndexPath(row: 0, section: firstVisible.section), at: .top, animated: true)
		}

		if let firstVisible = collectionView.indexPathsForVisibleItems.filter({ indexPath in
			return sections[indexPath.section].directionToDragNextSection == scrollView.scrollDirection && sections[indexPath.section].shouldDragToTheNextSection
		}).first {
			if sections.indices.contains(firstVisible.section + 1) {
				collectionView.scrollToItem(at: IndexPath(row: 0, section: firstVisible.section + 1), at: .top, animated: true)
			}

		}
	}
}
