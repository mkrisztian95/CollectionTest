//
//  TestContentView.swift
//  PiriuCollectionTest
//
//   
//

import UIKit

@IBDesignable
class TestContentView: UIView {
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var collection: UICollectionView!

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

		collection.register(TestCollectionCell.self, forCellWithReuseIdentifier: TestCollectionCell.reuseId)
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
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionCell.reuseId, for: indexPath) as? TestCollectionCell else { return UICollectionViewCell(frame: .zero) }
		cell.setUp(color: .black.withAlphaComponent(CGFloat.random(in: 0.1...0.75)))
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width / 2 - 2 , height: 300.0)
	}
}
