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

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.registerHeader(HeaderView.self)
		tableView.delegate = self
		tableView.dataSource = self

		tableView.reloadData()
	}

	private func firstVisibleToScrollToTop(_ scrollView: UIScrollView) -> IndexPath? {
		return tableView.indexPathsForVisibleRows?.filter({ indexPath in
			return sections[indexPath.section].directionToScrollSectionToTop == scrollView.scrollDirection && sections[indexPath.section].autoScrollToTheTopOfDisplay
		}).first
	}

	private func firstVisibleToScrollNext(_ scrollView: UIScrollView) -> IndexPath? {
		tableView.indexPathsForVisibleRows?.filter({ indexPath in
			return sections[indexPath.section].directionToDragNextSection == scrollView.scrollDirection && sections[indexPath.section].shouldDragToTheNextSection
		}).first
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, ContentScrollBridgeProtocol {
	// MARK: - collection Items
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].numberOfCells
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = sections[indexPath.section]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.reuseId, for: indexPath) as? TestTableViewCell else { return UITableViewCell(frame: .zero) }
		switch sections[indexPath.section] {
		case .profileInfo:
			cell.setUp(color: .black.withAlphaComponent(CGFloat.random(in: 0.1...0.75)))
			return cell
		case .content:

			// MOC
			let view = ScrollableStackView(frame: section.getCellSize(frame: tableView.frame))
			let tView1 = TestContentView(frame: section.getCellSize(frame: tableView.frame))
			tView1.delegate = self
			let tView2 = UIView(frame: section.getCellSize(frame: tableView.frame))
			tView2.backgroundColor = .blue
			let tView3 = UIView(frame: section.getCellSize(frame: tableView.frame))
			tView3.backgroundColor = .red
			view.setUp(items: [tView1, tView2, tView3])
			cell.setUp(with: view)
			// MOC

			return cell
		}
	}

	// MARK: - Frame/Size/header
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return sections[indexPath.section].getCellSize(frame: tableView.frame).size.height
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return sections[section].getHeaderSize(frame: tableView.frame).height
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if !sections[section].hasHeader {
			return  nil
		}

		guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseId) as? HeaderView else {return nil}
		return headerView
	}

	// MARK: - ContentScrollBridgeProtocol
	func shouldTranslateScrollToParent() {
		self.tableView.setContentOffset(.zero, animated: true)
	}

	// MARK:- scroll handling
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		if let firstVisible = self.firstVisibleToScrollToTop(scrollView), sections.indices.contains(firstVisible.section + 1) {
			tableView.cellForRow(at: IndexPath(row: 0, section: firstVisible.section + 1))?.isUserInteractionEnabled = false
		}

		if let firstVisible = self.firstVisibleToScrollNext(scrollView), sections.indices.contains(firstVisible.section + 1) {
			tableView.cellForRow(at: IndexPath(row: 0, section: firstVisible.section + 1))?.isUserInteractionEnabled = true
		}
	}

	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		if let firstVisible = self.firstVisibleToScrollToTop(scrollView) {
			if sections.indices.contains(firstVisible.section + 1) {
				let indexPath = IndexPath(row: 0, section: firstVisible.section + 1)
				tableView.cellForRow(at: indexPath)?.isUserInteractionEnabled = false
			}
			tableView.scrollToRow(at: IndexPath(row: 0, section: firstVisible.section), at: .top, animated: true)
		}

		if let firstVisible = firstVisibleToScrollNext(scrollView) {
			if sections.indices.contains(firstVisible.section + 1) {
				let indexPath = IndexPath(row: 0, section: firstVisible.section + 1)
				tableView.cellForRow(at: indexPath)?.isUserInteractionEnabled = true
				tableView.scrollToRow(at: indexPath, at: .top, animated: true)
			}
		}
	}
}
