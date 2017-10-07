//
//  BaseViewController.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var sideMenuOverlay: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
		self.automaticallyAdjustsScrollViewInsets = false
    }
	
    func addSideMenuNavigationButton() {
        self.navigationItem.hidesBackButton = true
        
        let hamburgerButton = UIBarButtonItem(image: UIImage(named: "ic_nav_hamburger"), style: .plain,
                                              target: self, action: #selector(BaseViewController.toggleSideMenu))
        hamburgerButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = hamburgerButton
    }
	
	func setNavigationBar(with title: String) {
		self.navigationController?.visibleViewController?.navigationItem.title = title
	}
	
	func setBarTint(with color: UIColor) {
		self.navigationController?.navigationBar.barTintColor = color
	}

    func toggleSideMenu() {
        if self.isSideMenuOpen() {
            self.hideSideMenu()
        } else {
            self.showSideMenu()
            self.addGestureOverlayForCurrentView()
        }
    }
    
    func isSideMenuOpen() -> Bool {
        let frame = self.navigationController?.view.frame
        if frame?.origin.x != 0 {
            return true
        }
        return false
    }

    func hideSideMenu() {
        sideMenuOverlay?.removeFromSuperview()
        UIView.animate(withDuration: 0.6) { () -> Void in
            if let navController = self.navigationController {
                var frame = navController.view.frame
                frame.origin.x = 0
                navController.view.frame = frame
            }
        }
    }
    
    func showSideMenu() {
        UIView.animate(withDuration: 0.5) { () -> Void in
            if let navController = self.navigationController {
                var frame = navController.view.frame
                frame.origin.x += 260
                navController.view.frame = frame
            }
        }
        self.sideMenuOverlay = UIView(frame: self.view.bounds)
        self.view.addSubview(self.sideMenuOverlay!)
    }
    
    func addGestureOverlayForCurrentView() {
        let tapGestureDismiss = UITapGestureRecognizer(target: self,
                                                       action: #selector(BaseViewController.hideSideMenu))
        
        self.sideMenuOverlay?.addGestureRecognizer(tapGestureDismiss)
    }
    
}
