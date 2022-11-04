//
//  HeaderView.swift
//

import UIKit

class HeaderView: UICollectionReusableView {
	static let reuseId: String = "HeaderView" 
	func setUp() {
		self.subviews.forEach { view in
			view.removeFromSuperview()
		}
		let view = UIView(frame: self.bounds)
		view.backgroundColor = .red.withAlphaComponent(0.5)
		self.addSubview(view)
		let label = UILabel(frame: self.bounds)
		label.textAlignment = .center
		label.text = "Header"
		self.addSubview(label)
		self.backgroundColor = .white
	}
}
