//
//  TestCollectionCell.swift
//

import Foundation
import UIKit

class TestCollectionCell: UICollectionViewCell {
	static let reuseId: String = "TestCollectionCell"
	
	func setUp(color: UIColor) {
		self.subviews.forEach { view in
			view.removeFromSuperview()
		}
		self.backgroundColor = color
		let label = UILabel(frame: self.bounds)
		label.textAlignment = .center
		label.text = "Row/Cell"
		self.addSubview(label)
	}

	func setUp(with content: UIView) {
		self.addSubview(content)

		content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		content.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
		content.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
		content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
	}
}
