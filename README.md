<p><h1 align="left">SKMenu</h1></p>

<img align="center" src="https://github.com/vensan7888/SKMenu/blob/master/demo.gif" width="480" />


<p><h4>Easily customizable menu view created with help of UIScrollView </h4></p>


![Version](https://img.shields.io/cocoapods/v/SKMenu.svg)
![License](https://img.shields.io/cocoapods/l/SKMenu.svg)
![Platform](https://img.shields.io/cocoapods/p/SKMenu.svg)

# Usage
1. Configure `SKMenuViewDataSource`, to set menu view & it's item properties
```swift
extension YourMenuDataSourceClass: SKMenuViewDataSource {

	func menuViewItemSpacing(_ menuView: SKMenuView) -> CGFloat {
		return 10.0
	}

	func menuViewItemZoomScale(_ menuView: SKMenuView) -> CGFloat {
		return 1.25
	}

	func menuViewNumberofItems(_ menuView: SKMenuView) -> Int {
		return self.menuItems.count
	}

	// menu item properties (image & selection color) at index
	func menuView(_ menuView: SKMenuView, menuItemAt index: Int) -> SKMenuViewItem {
		return SKMenuViewItem(image: UIImage(), selectionColor: .white)
	}

	func menuViewItemSize(_ menuView: SKMenuView) -> CGSize {
		return CGSize(width: 55, height: 50)
	}

	// Configure different color combinations (selection state, normal state & back ground) for better user experience
	func menuViewNormalStateBackgroundColor(_ menuView: SKMenuView) -> UIColor {
		return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
	}

	func menuViewSelectionStateBackgroundColor(_ menuView: SKMenuView) -> UIColor {
		return .clear
	}

	func menuViewItemNormalStateColor(_ menuView: SKMenuView) -> UIColor {
		return .white
	}
}
```
2. Initialize `SKMenuView` programatically.
```swift
// layouts are 4 types, .top(offset), .left(offset), .bottom(offset), .right(offset)
// animationStyle can be confiugred as .plain / .zoom
let menu = SKMenuView.initializeMenu(on: self.view,
                                     dataSource: self,
                                     layout: .right(10),
                                     animateStyle: .plain)
```
3. Set, Configure Delegate `SKMenuViewDelegate`
```swift
menu.delegate = self

extension YourMenuDelegateClass: SKMenuViewDelegate {
	// Perform actions intended to selected index
	func menuView(_ menuView: SKMenuView, didSelectRowAt index: Int) {
	}
}

```
4. Load menu
```swift
menu.loadMenu()
```
5. Useful methods
```swift
// can select menu item on demand.
menu.selectMenuItem(at: 2)
```

## SKMenu-Sample

To run the SKMenu-Sample project, clone the repo, and run `pod install` from the SKMenu-Sample directory first.

## Requirements
* SKMenu-Sample is built on
* iOS 12.2+ / macOS 10.14+
* Xcode 11.0+

## Swift Package
```
add swift package dependency from "https://github.com/vensan7888/SKMenu.git"
```

## Cocoa Pod Installation

SKMenu is available through [CocoaPods](https://cocoapods.org). 
To install it, simply add the following line to your Podfile:

```ruby
	pod 'SKMenu', '0.0.1'
```

## Author

Sandeep Kumar M V, venu.medidi@gmail.com

## License

SKMenu is available under the MIT license. See the LICENSE file for more info.
