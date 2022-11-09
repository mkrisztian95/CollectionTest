//
//  TestContentView.swift
//  PiriuCollectionTest
//

import UIKit

protocol ContentScrollBridgeProtocol: AnyObject {
	func shouldTranslateScrollToParent()
}

@IBDesignable
class TestContentView: UIView {
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var collection: UICollectionView!
	weak var delegate: ContentScrollBridgeProtocol?

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		let bundle = Bundle(for: type(of: self))
		bundle.loadNibNamed("TestContentView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		contentView.backgroundColor = .red
		collection.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: TestCollectionViewCell.reuseId)
		collection.delegate = self
		collection.dataSource = self
		collection.reloadData()
	}
}

extension TestContentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 13
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.reuseId, for: indexPath) as? TestCollectionViewCell else { return UICollectionViewCell(frame: .zero) }
		cell.setUp(color: .black.withAlphaComponent(CGFloat.random(in: 0.1...0.75)))
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width / 2 - 2 , height: 300.0)
	}

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		if scrollView.scrollDirection == .up && scrollView.contentOffset.y == 0 {
			delegate?.shouldTranslateScrollToParent()
		}
	}
}
