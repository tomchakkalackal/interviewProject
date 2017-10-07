//
//  HomeViewController.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        addSideMenuNavigationButton()
		setBarTint(with: navigationBarTintColor)
    }
	
	func exitApp() {
		
	}
	
	//MARK:- Button Actions
	
	@IBAction func exitButtonTapped(_ sender: Any) {
		let exitMessage = "Are you sure you want to exit the app."
		let alert = UIAlertController(title: "Exit App", message: exitMessage, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
			UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

}
