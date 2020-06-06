//
//  SelectedViewController.swift
//  SKMenu-Sample
//
//  Created by Sandeep Kumar M V on 30/5/20.
//  Copyright © 2020 Sandeep Kumar M V. All rights reserved.
//

import UIKit

class SelectedViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	var viewTitle: String = "Title"
	var color: UIColor = .black

	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.titleLabel.textColor = self.color
		self.titleLabel.text = ""
		self.imageView.image = UIImage(named: self.viewTitle)
		self.imageView.contentMode = .scaleAspectFill
    }

	func updateMenu(title: String, color: UIColor) {
		self.color = color
		self.viewTitle = title
	}

}
