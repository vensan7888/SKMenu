//
//  SKMenuView_Private.swift
//  SKMenu
//
//  Created by Sandeep Kumar M V on 30/5/20.
//

import Foundation
import CoreGraphics
import UIKit

/// Purely Internal. representation of menuView laout with respect to X & Y axis
internal enum SKMenuViewLayoutType: Equatable {
	case vertical
	case horizontal
}

/// Default implementation for customizable dataSource methods.
public extension SKMenuViewDataSource {

	func menuViewItemSlideAnimationTime(_ menuView: SKMenuView) -> Double {
		return 1.25
	}

	func menuViewItemZoomScale(_ menuView: SKMenuView) -> CGFloat {
		return 1.25
	}

	func menuViewItemNormalStateColor(_ menuView: SKMenuView) -> UIColor {
		return .lightGray
	}

	func menuViewNormalStateBackgroundColor(_ menuView: SKMenuView) -> UIColor {
		return .white
	}

	func menuViewSelectionStateBackgroundColor(_ menuView: SKMenuView) -> UIColor {
		return .white
	}
}

/// Internal methods of the SKMenuView to perform animation
extension SKMenuView {
	internal func findLayoutType(for layout: SKMenuViewLayout) -> SKMenuViewLayoutType {
		var layoutType: SKMenuViewLayoutType = .horizontal
		switch layout {
		case .top(_), .bottom(_):
			layoutType = .horizontal
		case .left(_), .right(_):
			layoutType = .vertical
		}
		return layoutType
	}

	internal func updateView(layout: SKMenuViewLayout, dataSource: SKMenuViewDataSource, parentView: UIView) {
		let size = self.viewSize(source: dataSource)
		let viewCenter = self.viewCenter(for: layout, size: size, parentView: parentView)
		self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		self.center = viewCenter
		parentView.addSubview(self)
	}

	internal func viewCenter(for layout: SKMenuViewLayout, size: CGSize, parentView: UIView) -> CGPoint {
		var viewCenter = parentView.center
		switch layout {
		case .top(let offset):
			viewCenter.y = offset + (size.height/2.0)
		case .bottom(let offset):
			viewCenter.y = parentView.frame.height - offset - (size.height/2.0)
		case .left(let offset):
			viewCenter.x = offset + (size.width/2.0)
		case .right(let offset):
			viewCenter.x = parentView.frame.width - offset - (size.width/2.0)
		}
		return viewCenter
	}

	internal func viewSize(source: SKMenuViewDataSource) -> CGSize {
		let size = self.scaledItemSize(source: source)
		let items = source.menuViewNumberofItems(self)
		let spacing = self.minimumItemSpacing()
		var targetSize = size

		if self.layout == .horizontal {
			targetSize.width = (CGFloat(items) * (size.width + spacing)) + spacing
		} else {
			targetSize.height = (CGFloat(items) * (size.height + spacing)) + spacing
		}
		return targetSize
	}

	internal func scaledItemSize(source: SKMenuViewDataSource) -> CGSize {
		var targetSize = source.menuViewItemSize(self)
		guard self.animateStyle == .zoom else {
			return targetSize
		}
		let scale = self.minimumZoomScale()
		var slideScale: CGFloat = 0
		if scale > 1.0 {
			slideScale = scale - 1.0
		}
		if self.layout == .horizontal {
			targetSize.height = targetSize.height + (targetSize.height * slideScale)
		} else {
			targetSize.width = targetSize.width + (targetSize.width * slideScale)
		}
		return targetSize
	}

	internal func setupMenuView(source: SKMenuViewDataSource) {
		for subView in self.subviews {
			subView.removeFromSuperview()
		}
		let size = self.scaledItemSize(source: source)
		var menuSize = size
		if layout == .horizontal {
			menuSize.width = self.frame.size.width
		} else {
			menuSize.height = self.frame.size.height
		}
		let menuView = UIView(frame: CGRect(x: 0, y: 0, width: menuSize.width, height: menuSize.height))
		let menuSelectionView = UIScrollView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))

		menuView.backgroundColor = source.menuViewNormalStateBackgroundColor(self)
		menuView.isUserInteractionEnabled = false
		menuView.clipsToBounds = true
		menuView.layer.cornerRadius = 5.0
		menuSelectionView.backgroundColor = source.menuViewSelectionStateBackgroundColor(self)
		menuSelectionView.isUserInteractionEnabled = false
		menuSelectionView.clipsToBounds = true
		menuSelectionView.layer.cornerRadius = 5.0

		self.addSubview(menuView)
		self.addSubview(menuSelectionView)

		self.setupMenuItems(source: source, size: size, menuView: menuView, menuSelectionView: menuSelectionView)
		self.menuSelectionView = menuSelectionView
	}

	internal func setupMenuItems(source: SKMenuViewDataSource,
								size: CGSize,
								menuView: UIView, menuSelectionView: UIScrollView) {
		let items = source.menuViewNumberofItems(self)
		let spacing = self.minimumItemSpacing()
		for i in 0..<items {
			var x: CGFloat = 0
			var y: CGFloat = 0
			if layout == .horizontal {
				x = (CGFloat(i) * (size.width + spacing)) + spacing
			} else {
				y = (CGFloat(i) * (size.height + spacing)) + spacing
			}
			let itemFrame = CGRect(x: x , y: y, width: size.width, height: size.height)
			let itemView = UIImageView(frame: itemFrame)
			itemView.tintColor = source.menuViewItemNormalStateColor(self)
			let selectionItemView = UIImageView(frame: itemFrame)
			let menuItem = source.menuView(self, menuItemAt: i)
			itemView.image = menuItem.image
			itemView.contentMode = .scaleAspectFit
			selectionItemView.image = menuItem.image
			selectionItemView.tintColor = menuItem.color
			selectionItemView.contentMode = .scaleAspectFit

			menuView.addSubview(itemView)
			menuSelectionView.addSubview(selectionItemView)
		}
	}

	func targetPoint(to index: Int, source: SKMenuViewDataSource) -> CGPoint {
		let spacing = self.minimumItemSpacing()
		var targetPoint: CGPoint = CGPoint(x: 0, y: 0)
		let size = self.scaledItemSize(source: source)
		if layout == .horizontal {
			let x = (CGFloat(index) * (size.width + spacing)) + spacing
			targetPoint = CGPoint(x: x, y: 0)
		} else {
			let y = (CGFloat(index) * (size.height + spacing)) + spacing
			targetPoint = CGPoint(x: 0, y: y)
		}
		return targetPoint
	}

	func slideTransform(targetPoint: CGPoint, completionBlock: @escaping () -> Void) {
		guard let source = self.dataSource else {
			return
		}
		let time = source.menuViewItemSlideAnimationTime(self)
		let size = self.scaledItemSize(source: source)
		let slideScale = self.minimumZoomScale()
		UIView.animate(withDuration: TimeInterval(time), animations: { [weak self] in
			self?.menuSelectionView?.frame = CGRect(x: targetPoint.x, y: targetPoint.y, width: size.width, height: size.height)
			self?.menuSelectionView?.setContentOffset(targetPoint, animated: false)
			if let style = self?.animateStyle, style == .zoom {
				self?.menuSelectionView?.transform = CGAffineTransform(scaleX: slideScale, y: slideScale)
			}
		}) { [weak self] (_) in
			completionBlock()
			if let style = self?.animateStyle, style == .zoom {
				self?.resetZoomTransform()
			}
		}
	}

	func resetZoomTransform() {
		UIView.animate(withDuration: 0.25) { [weak self] in
			self?.menuSelectionView?.transform = CGAffineTransform(scaleX: 1, y: 1)
		}
	}

	func minimumItemSpacing() -> CGFloat {
		var spacing = self.dataSource?.menuViewItemSpacing(self) ?? 1.0
		spacing = spacing < 1.0 ? 1.0 : spacing
		return spacing
	}

	func minimumZoomScale() -> CGFloat {
		var scale = self.dataSource?.menuViewItemZoomScale(self) ?? 1.0
		scale = scale < 1.0 ? 1.0 : scale
		return scale
	}
}
