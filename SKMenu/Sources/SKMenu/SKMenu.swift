//
//  SKMenuSettings.swift
//  SKMenu
//
//  Created by Sandeep Kumar M V on 30/5/20.
//

import Foundation
import CoreGraphics
import UIKit

/**
Menu views manage only the presentation of their data; they do not manage the data itself. To manage the data, you provide the menu with a data source object—that is, an object that implements the SKMenuViewDataSource protocol. A data source object responds to data-related requests from the menu. It also manages the menu's data directly, or coordinates with other parts of your app to manage that data. Other responsibilities of the data source object include:

- Reporting the items in the menu.
- Providing SKMenuItem (selection color & image) for each item of the menu.
- Responding to user or menu-initiated updates that require changes to the underlying data.
*/
public protocol SKMenuViewDataSource: class {

	/// Tells the data source to return the number of items in a menu view.
	/// It is recommended to limit the number of items as per screen size.
	///
	/// - Parameters:
	/// 	- menuView: a menu-view requesting number of menu items
	/// - Returns: Count of Menu items to be present
	func menuViewNumberofItems(_ menuView: SKMenuView) -> Int

	/// Asks the data source for a menu item to insert in a particular location of the menu view.
	/// - Parameters:
	///   - menuView: a menu-view requesting menu-item
	///   - index: An index locating a position in menuView.
	/// - Returns: An object holding the values of item( selection color, image)
	func menuView(_ menuView: SKMenuView, menuItemAt index: Int) -> SKMenuViewItem

	/// Asks the data source size of the menu Items in menu view.
	/// - Parameter menuView: a menu-view requesting menu item size
	/// - Returns: Size of the items
	func menuViewItemSize(_ menuView: SKMenuView) -> CGSize

	/// Asks the data source, spacing between  menu items of the menu of menu view.
	/// minimum value should start from 1.0
	/// - Parameter menuView: a menu-view requesting menu item's spacing
	/// - Returns: Spacing between menu items
	func menuViewItemSpacing(_ menuView: SKMenuView) -> CGFloat

	/// Asks the data source, slide animation time between current menu item & selected menu item of menu view.
	/// - Parameter menuView: a menu-view requesting menu item's slide animation time.
	/// - Returns: Sliding anination time between menu items
	func menuViewItemSlideAnimationTime(_ menuView: SKMenuView) -> Double

	/// Asks the data source, zoom scale of slide animation between current menu item & selected menu item of menu view.
	/// minimum value should start from 1.0
	/// - Parameter menuView: a menu-view requesting menu item slide animation time.
	/// - Returns: Sliding anination time between menu items
	func menuViewItemZoomScale(_ menuView: SKMenuView) -> CGFloat

	/// Asks the data source, tint color of menu items of menu view in normal state .
	/// - Parameter menuView: a menu-view requesting menu item's normal state color.
	/// - Returns: Normal state color of menu items
	func menuViewItemNormalStateColor(_ menuView: SKMenuView) -> UIColor

	/// Asks the data source, background color of menu view  in normal state.
	/// - Parameter menuView: a menu-view requesting background color in normal state.
	/// - Returns: Normal state color of menu view
	func menuViewNormalStateBackgroundColor(_ menuView: SKMenuView) -> UIColor

	/// Asks the data source, background color of menu view  in selection state.
	/// - Parameter menuView: a menu-view requesting background color in selection state.
	/// - Returns: Selection state color of menu view
	func menuViewSelectionStateBackgroundColor(_ menuView: SKMenuView) -> UIColor
}

/// Use below method of this protocol to manage the following features
public protocol SKMenuViewDelegate: class {
	/// Tells the delegate that the specified menu item  is now selected.
	/// - Parameters:
	///   - menuView: A menu-view object informing the delegate about the new item selection.
	///   - index: An index locating the new selected item in menuView.
	func menuView(_ menuView: SKMenuView, didSelectRowAt index: Int)
}

/// The visual representation data needed to create a single menu item in a menu view.
/// Menu item is expected to have normal state color & selection state color.
/// Where as normal state color is accepted as part of the initilizing properties
public struct SKMenuViewItem {
	/// Menu item image
	var image: UIImage
	/// Menu item selection color
	var color: UIColor

	/// Initializer to MenuView's item
	/// - Parameters:
	///   - image: image to display for menu item
	///   - selectionColor: color to display on selection
	public init(image: UIImage, selectionColor: UIColor) {
		self.image = image
		self.color = selectionColor
	}
}

/// Tells menu view, the direction & place render on parent view
public enum SKMenuViewLayout: Equatable {
	/// Value given is the position of menu view from parent view's top
	case top(CGFloat = 50)
	/// Value given is the position of menu view's  from parent view's bottom
	case bottom(CGFloat = 50.0)
	/// Value given is the position of menu view's from parent view's left
	case left(CGFloat = 50)
	/// Value given is the position of menu view's from parent view's right
	case right(CGFloat = 50)
}

/// Tell menu view, the animation style to show selection of menuView item
public enum SKMenuViewAnimationStyle {
	/// Performs smooth slide animation, pass through the selection colors of in between menuView items,
	/// while reaching towards selected menuView item
	case plain
	/// Performs smooth slide & zoom out animation, pass through the selection colors of in between menuView items,
	/// while reaching towards selected menuView item
	case zoom
}
