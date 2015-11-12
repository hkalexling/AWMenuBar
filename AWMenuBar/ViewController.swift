//
//  ViewController.swift
//  AWMenuBar
//
//  Created by Alex Ling on 13/11/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AWMenuBarDelegate{
	@IBOutlet weak var awMenuBar: AWMenuBarView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor(red: 51/255, green: 86/255, blue: 136/255, alpha: 1)
		self.awMenuBar.backgroundColor = UIColor(red: 58/255, green: 95/255, blue: 149/255, alpha: 1)
		self.awMenuBar.delegate = self

		let baseY : CGFloat = 180
		self.awMenuBar.addButton(baseY, text: "ABOUT")
		self.awMenuBar.addButton(baseY + 80, text: "SHARE")
		self.awMenuBar.addButton(baseY + 160, text: "ACTIVITY")
		self.awMenuBar.addButton(baseY + 240, text: "SETTINGS")
		self.awMenuBar.addButton(baseY + 320, text: "CONTACT")
		
		self.awMenuBar.setUp()
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	func buttonTapped(sender: UIButton) {
		print (sender.currentTitle!)
		self.awMenuBar.closeMenu()
	}

}

