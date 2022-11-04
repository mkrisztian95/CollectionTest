//
//  ScrollableCollectionSections.swift
//

import Foundation
import UIKit

enum ScrollableCollectionFit {
	case aspectFill
	case aspectFit
}

enum ScrollableCollectionSections {
	case profileInfo
	case content

	var hasHeader: Bool {
		switch self {
		case .profileInfo:
			return false
		case .content:
			return true
		}
	}

	var numberOfCells: Int {
		switch self {
		case .profileInfo:
			return 1
		case .content:
			return 1
		}
	}

	var directionToScrollSectionToTop: UIScrollView.DragDirection? {
		switch self {
		case .profileInfo:
			return .up
		case .content:
			return nil
		}
	}

	var autoScrollToTheTopOfDisplay: Bool {
		switch self {
		case .profileInfo:
			return true
		case .content:
			return false
		}
	}

	var directionToDragNextSection: UIScrollView.DragDirection? {
		switch self {
		case .profileInfo:
			return .down
		case .content:
			return nil
		}
	}

	var shouldDragToTheNextSection: Bool {
		switch self {
		case .profileInfo:
			return true
		case .content:
			return false
		}
	}

	func getCellSize(frame: CGRect) -> CGRect {
		switch self {
		case .profileInfo:
			return CGRect(x: 0, y: 0, width: frame.size.width, height: 400.0)
		case .content:
			let width = frame.size.width
			let height = frame.height - getHeaderSize(frame: frame).height
			return CGRect(x: 0, y: 0, width: width, height: height)
		}
	}

	func getHeaderSize(frame: CGRect) -> CGSize {
		switch self {
		case .profileInfo:
			return .zero
		case .content:
			return CGSize(width: frame.width, height: 100.0)
		}
	}
}

extension UIScrollView {
	enum DragDirection {
		case up
		case down
	}

	var scrollDirection: DragDirection {
		let translation = self.panGestureRecognizer.translation(in: self.superview)
		return translation.y > 0 ? .up : .down
	}
}

