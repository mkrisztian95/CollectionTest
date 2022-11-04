//
//  PagerTest.swift
//  PiriuCollectionTest
//
//   
//

import Foundation
import UIKit


class ScrollableStackView: UIView {

	lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 0
		return stackView
	}()

	lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.addSubview(stackView)
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.isPagingEnabled = true
		return scrollView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	func setUp(items:[UIView]) {
		self.addSubview(scrollView)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
		stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

		for item in items {
			item.translatesAutoresizingMaskIntoConstraints = true
			item.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
			item.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
			stackView.addArrangedSubview(item)
		}
	}
}
