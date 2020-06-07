//
//  SKMenuView.swift
//  SKMenu
//
//  Created by Sandeep Kumar M V on 30/5/20.
//

import Foundation
import UIKit

/// A view that presents data using menuItems arranged in a single row.
public class SKMenuView: UIView {

	/// The object that acts as the delegate of the menu view.
	weak public var delegate: SKMenuViewDelegate?
	/// The object that acts as the data source of the menu view.
	weak var dataSource: SKMenuViewDataSource?

	internal var menuSelectionView: UIScrollView?
	internal var layout: SKMenuViewLayoutType = .horizontal
	internal var animateStyle: SKMenuViewAnimationStyle = .plain
	internal var selectedIndex = -1
	internal var defaultInex = 0

	/// Initializes and returns a menu view object having the given frame and style.
	/// - Parameters:
	///   - parentView: view to add menu view on.
	///   - dataSource: instance to access data, to create menu view
	///   - layout: SKMenuViewLayout with the space between respective side of the view
	///   - animateStyle: .zoom or .plain
	///   - defaultMenuIndex: select menu view index by default
	public class func initializeMenu(on parentView: UIView,
									 dataSource: SKMenuViewDataSource,
									 layout: SKMenuViewLayout,
									 animateStyle: SKMenuViewAnimationStyle,
									 defaultMenuIndex: Int = 0) -> SKMenuView {
		let view = SKMenuView()
		view.dataSource = dataSource
		view.layout = view.findLayoutType(for: layout)
		view.defaultInex = defaultMenuIndex
		view.animateStyle = animateStyle
		
		view.updateView(layout: layout, dataSource: dataSource, parentView: parentView)
		return view
	}

	/// Reloads the menu items of the table view.
	public func loadMenu() {
		self.isMultipleTouchEnabled = false
		guard let source = self.dataSource else {
			return
		}
		self.setupMenuView(source: source)
		self.selectMenuItem(at: defaultInex)
	}

	/// Select menu item on demand.
	/// - Parameter index: index of the menu item
	public func selectMenuItem(at index: Int) {
		guard let source = self.dataSource, let count = self.dataSource?.menuViewNumberofItems(self),
			index < count, selectedIndex != index else {
				return
		}
		selectedIndex = index
		let targetPoint = self.targetPoint(to: index, source: source)
		self.isUserInteractionEnabled = false
		self.slideTransform(targetPoint: targetPoint) { [weak self] in
			if let self = self {
				self.delegate?.menuView(self, didSelectRowAt: index)
			}
			self?.isUserInteractionEnabled = true
		}
	}

	override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		let touchPoint = touch.location(in: self)
		let index = self.indexFor(touchPoint: touchPoint)
		selectMenuItem(at: index)
	}
}
