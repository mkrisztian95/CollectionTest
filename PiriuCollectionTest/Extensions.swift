//
//  Extensions.swift
//  PiriuCollectionTest
//

import Foundation
import UIKit

extension UITableView {
	func dequeueCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(
			withIdentifier: type.identifier,
			for: indexPath) as! T
	}

	func registerCell<T: UITableViewCell>( _ type: T.Type) {
		self.register(type.nib, forCellReuseIdentifier: type.identifier)
	}

	func registerHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) {
		self.register(
			type.nib,
			forHeaderFooterViewReuseIdentifier: type.identifier)
	}
}

extension UITableView {
  func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
	return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
  }
}

protocol NibRepresentable {
	static var nib: UINib { get }
	static var identifier: String { get }
}

extension UIView: NibRepresentable {
	class var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}

	class var identifier: String {
		return String(describing: self)
	}
}

extension NibRepresentable where Self: UIView {
	static var viewFromNib: Self {
		return Bundle.main.loadNibNamed(
			Self.identifier,
			owner: nil, options: nil)?.first as! Self
	}
}

extension UITableView {
  func scrollToTop(animated: Bool) {
//	DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
		self.scrollTo(direction: .top)
//	}
  }
}

extension UIScrollView {

	enum ScrollDirection {
		case top
		case right
		case bottom
		case left

		func contentOffsetWith(_ scrollView: UIScrollView) -> CGPoint {
			var contentOffset = CGPoint.zero
			switch self {
				case .top:
					contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
				case .right:
					contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
				case .bottom:
					contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
				case .left:
					contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
			}
			return contentOffset
		}
	}

	func scrollTo(direction: ScrollDirection, animated: Bool = true) {
		self.setContentOffset(direction.contentOffsetWith(self), animated: animated)
	}
}
