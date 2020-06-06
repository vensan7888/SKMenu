//
//  ViewController.swift
//  SKMenu-Sample
//
//  Created by Sandeep Kumar M V on 30/5/20.
//  Copyright © 2020 Sandeep Kumar M V. All rights reserved.
//

import UIKit
import SKMenu

struct AppMenuItem {
	var title: String
	var selectionColor: UIColor
	var imageName: String
}

class ViewController: UIViewController {

	var menuView: SKMenuView?
	var menuItems: [AppMenuItem] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		let names = ["CaptainAmerica", "iRonMan", "Panther", "Thor", "Hulk"]
		let colors: [UIColor] = [.green, UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 0.8), .red, .systemPink, .yellow]

		for i in 1...5 {
			let imageName = "menu_\(i)"
			let item = AppMenuItem(title: names[i-1],
								   selectionColor: colors[i-1],
								   imageName: imageName)
			menuItems.append(item)
		}

		let menu = SKMenuView.initializeMenu(on: self.view,
											 dataSource: self,
											 layout: .top(40),
											 animateStyle: .plain)
		menu.delegate = self
		self.menuView = menu
		self.menuView?.loadMenu()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

extension ViewController: SKMenuViewDataSource {

	func menuViewItemSpacing(_ menuView: SKMenuView) -> CGFloat {
		return 10.0
	}

	func menuViewItemZoomScale(_ menuView: SKMenuView) -> CGFloat {
		return 1.25
	}

	func menuViewNumberofItems(_ menuView: SKMenuView) -> Int {
		return self.menuItems.count
	}

	func menuView(_ menuView: SKMenuView, menuItemAt index: Int) -> SKMenuViewItem {
		let appMenuItem = self.menuItems[index]
		guard let image = UIImage(named: appMenuItem.imageName) else {
			return SKMenuViewItem(image: UIImage(), selectionColor: .white)
		}
		return SKMenuViewItem(image: image, selectionColor: appMenuItem.selectionColor)
	}

	func menuViewItemSize(_ menuView: SKMenuView) -> CGSize {
		return CGSize(width: 55, height: 50)
	}

	func menuViewNormalStateBackgroundColor(_ menuView: SKMenuView) -> UIColor {
		return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
	}

	func menuViewSelectionStateBackgroundColor(_ menuView: SKMenuView) -> UIColor {
		return .black
	}

	func menuViewItemNormalStateColor(_ menuView: SKMenuView) -> UIColor {
		return .black
	}
}

extension ViewController: SKMenuViewDelegate {

	func menuView(_ menuView: SKMenuView, didSelectRowAt index: Int) {
		print("selected index: \(index)")
		self.loadSelectedView(index: index)
	}
}

extension ViewController {

	func loadSelectedView(index: Int) {
		for child in self.children {
			child.removeFromParent()
		}
		if let selectedView = loadSelected() {
			let appMenuItem = self.menuItems[index]
			selectedView.updateMenu(title: appMenuItem.title, color: appMenuItem.selectionColor)
			self.addChild(selectedView)
			selectedView.view.frame = self.view.frame
			selectedView.view.alpha = 0.0
			self.view.addSubview(selectedView.view)
			selectedView.didMove(toParent: self)
			if let menu = self.menuView {
				self.view.bringSubviewToFront(menu)
			}
			UIView.animate(withDuration: 0.25) {
				selectedView.view.alpha = 1.0
			}
		}
	}

	func loadSelected() -> SelectedViewController? {
		let storyboard: UIStoryboard = UIStoryboard(name: "Main",
													bundle: Bundle(for: SelectedViewController.self))
		guard let selectedView = storyboard.instantiateViewController(withIdentifier: "Selected") as? SelectedViewController else {
			return nil
		}
		return selectedView
	}
}
